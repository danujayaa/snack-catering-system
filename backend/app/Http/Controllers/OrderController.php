<?php

namespace App\Http\Controllers;

use Midtrans\Snap;
use App\Models\Cart;
use Midtrans\Config;
use App\Models\Order;
use App\Models\Address;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;

class OrderController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
        Config::$serverKey = env('MIDTRANS_SERVER_KEY');
        Config::$clientKey = env('MIDTRANS_CLIENT_KEY');
        Config::$isProduction = env('MIDTRANS_IS_PRODUCTION');
        Config::$isSanitized = true;
        Config::$is3ds = true;
    }

    public function index()
    {
        $user = auth()->user();

        if ($user->role === 'admin' || $user->role === 'superadmin') {
            $orders = Order::with([
                'address',
                'orderItems.product' => function ($query) {
                    $query->withTrashed();
                },
                'user',
                'payments'
            ])->get();
        } else {
            $orders = Order::with(['address', 'orderItems.product' => function ($query) {
                    $query->withTrashed();
                }, 'user', 'payments'])
                ->where('user_id', $user->id)
                ->get();
        }

        return response()->json($orders);
    }

    public function search(Request $request)
    {
        $query = $request->input('query');

        $orders = Order::with(
            'user',
            'address',
            'orderItems.product',
            'payments',
        )
            ->where('id', $query)
            ->orWhereHas('user', function ($q) use ($query) {
                $q->where('name', 'like', "%{$query}%");
            })
            ->orWhereHas('address', function ($q) use ($query) {
                $q->where('penerima', 'like', "%{$query}%")
                    ->orWhere('label', 'like', "%{$query}%")
                    ->orWhere('alamat_lengkap', 'like', "%{$query}%");
            })
            ->get();

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'tgl_pesan' => 'required|date',
            'tgl_antar' => 'required|date',
            'jam' => 'required|string',
            'catatan' => 'nullable|string',
            'snap_token' => 'nullable|string',
            'transaction_status' => 'nullable|string',
            'payment_method' => 'nullable|string',
        ]);

        $user = Auth::user();
        $defaultAddress = Address::where('user_id', $user->id)->where('default', true)->first();

        if (!$defaultAddress) {
            return response()->json(['message' => 'Tidak ditemukan alamat default'], 400);
        }

        $cartItems = Cart::where('user_id', $user->id)->with('product')->get();

        if ($cartItems->isEmpty()) {
            return response()->json(['message' => 'Keranjang kosong'], 400);
        }

        DB::beginTransaction();
        try {
            $totalPrice = $cartItems->sum(function ($cartItem) {
                return $cartItem->product->price * $cartItem->jumlah;
            });

            $order = Order::create([
                'user_id' => $user->id,
                'address_id' => $defaultAddress->id,
                'total_price' => $totalPrice,
                'status' => 'unpaid',
                'tgl_pesan' => $validated['tgl_pesan'],
                'tgl_antar' => $validated['tgl_antar'],
                'jam' => $validated['jam'],
                'catatan' => $validated['catatan'],
            ]);

            foreach ($cartItems as $cartItem) {
                $order->orderItems()->create([
                    'product_id' => $cartItem->product_id,
                    'jumlah' => $cartItem->jumlah,
                    'harga' => $cartItem->product->price,
                ]);
            }

            $transactionDetails = [
                'order_id' => $order->id,
                'gross_amount' => $totalPrice,
            ];

            $itemDetails = $cartItems->map(function ($cartItem) {
                return [
                    'id' => $cartItem->product_id,
                    'price' => $cartItem->product->price,
                    'quantity' => $cartItem->jumlah,
                    'name' => $cartItem->product->name,
                ];
            })->toArray();

            $customerDetails = [
                'first_name' => $user->name,
                'email' => $user->email,
                'phone' => $defaultAddress->phone,
                'billing_address' => [
                    'address' => $defaultAddress->alamat_lengkap,
                    'city' => $defaultAddress->kecamatan . ', ' . $defaultAddress->kabupaten,
                    'postal_code' => $defaultAddress->kode_pos,
                    'country_code' => 'IDN'
                ],
                'shipping_address' => [
                    'first_name' => $defaultAddress->penerima,
                    'phone' => $defaultAddress->phone,
                    'address' => $defaultAddress->alamat_lengkap,
                    'city' => $defaultAddress->kecamatan . ', ' . $defaultAddress->kabupaten,
                    'postal_code' => $defaultAddress->kode_pos,
                    'country_code' => 'IDN'
                ]
            ];

            $payload = [
                'transaction_details' => $transactionDetails,
                'item_details' => $itemDetails,
                'customer_details' => $customerDetails,
                'expiry' => [
                    'start_time' => date("Y-m-d H:i:s O"),
                    'unit' => 'hour',
                    'duration' => 24
                ],
            ];

            $snapToken = Snap::getSnapToken($payload);

            $order->snap_token = $snapToken;
            $order->payment_method = $request->payment_method;
            $order->save();

            Cart::where('user_id', $user->id)->delete();

            DB::commit();

            return response()->json([
                'message' => 'Berhasil membuat pesanan',
                'order_id' => $order->id,
                'order' => $order,
                'snap_token' => $snapToken
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Gagal membuat pesanan', 'error' => $e->getMessage()], 500);
        }
    }

    public function updateStatus(Request $request, $id)
    {
        $order = Order::findOrFail($id);

        $request->validate([
            'status' => 'required|in:unpaid,pending,confirmed,delivered,completed,canceled',
        ]);

        $order->status = $request->input('status');
        $order->save();

        return response()->json(['message' => 'Status pesanan berhasil diperbarui', 'status' => $order->status]);
    }

    public function cancelOrder($orderId)
    {
        $user = Auth::user();

        $order = Order::where('id', $orderId)->where('user_id', $user->id)->first();

        if (!$order) {
            return response()->json(['message' => 'Pesanan tidak ditemukan atau Anda tidak memiliki izin untuk membatalkan pesanan ini'], 404);
        }

        if (in_array($order->transaction_status, ['settlement', 'cancel', 'deny', 'expire', 'failure'])) {
            return response()->json(['message' => 'Pesanan tidak dapat dibatalkan'], 400);
        }

        try {
            DB::beginTransaction();

            Log::info("Mencoba membatalkan pesanan dengan ID: $orderId, Status Transaksi: {$order->transaction_status}");

            // Panggil API Midtrans untuk membatalkan pesanan
            $midtransResponse = \Midtrans\Transaction::cancel($order->id);

            // Log respons mentah dari Midtrans untuk debugging
            Log::info("Midtrans Response: " . json_encode($midtransResponse));

            // Periksa jika respons adalah string "200" atau array dengan status_code
            if (is_string($midtransResponse) && $midtransResponse === '200') {
                // Jika berhasil, update status pesanan
                $order->status = 'canceled';
                $order->transaction_status = 'cancel';
                $order->snap_token = null;
                $order->save();

                DB::commit();

                Log::info("Pesanan ID: $orderId berhasil dibatalkan oleh pengguna ID: {$user->id}");

                return response()->json(['message' => 'Pesanan berhasil dibatalkan'], 200);
            } else {
                Log::error("Format respons tidak valid dari Midtrans: " . json_encode($midtransResponse));

                $errorMessage = isset($midtransResponse['status_message']) ? $midtransResponse['status_message'] : 'Tidak ada pesan kesalahan yang tersedia';
                return response()->json([
                    'message' => 'Gagal membatalkan pesanan di Midtrans',
                    'error' => $errorMessage,
                ], 400);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            // Log error lebih mendetail
            Log::error('Gagal membatalkan pesanan: ' . $e->getMessage());
            return response()->json(['message' => 'Gagal membatalkan pesanan'], 500);
        }
    }

    public function topProductOrders()
    {
        $topProductOrders = OrderItem::select(
            'products.name as product_name',
            'products.image as product_image',
            DB::raw('SUM(order_items.jumlah) as total_quantity')
        )
            ->join('products', 'products.id', '=', 'order_items.product_id')
            ->groupBy('products.name', 'products.image')
            ->orderBy('total_quantity', 'desc')
            ->get()
            ->map(function ($item) {
                $item->product_image = url($item->product_image);
                return $item;
            });;

        return response()->json($topProductOrders);
    }
}
