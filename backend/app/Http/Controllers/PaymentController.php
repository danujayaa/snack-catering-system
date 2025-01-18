<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PaymentController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index()
    {
        $payments = Payment::all();
        return response()->json($payments);
    }

    public function search(Request $request)
    {
        $query = $request->input('query');

        $payments = Payment::where('order_id', 'LIKE', "%{$query}%")->get();

        return response()->json([
            'success' => true,
            'data' => $payments,
        ], 200);
    }

    public function notificationHandler()
    {
        try {
            $notif = request()->all();

            $transactionStatus = $notif['transaction_status'] ?? null;
            $orderId = $notif['order_id'] ?? null;
            $fraudStatus = $notif['fraud_status'] ?? null;
            $transactionId = $notif['transaction_id'] ?? null;
            $grossAmount = $notif['gross_amount'] ?? null;
            $paymentType = $notif['payment_type'] ?? null;
            $transactionTime = $notif['transaction_time'] ?? null;
            $paymentCode = $notif['payment_code'] ?? null;

            if (!$orderId || $orderId <= 0) {
                Log::error('ID pesanan tidak valid: ' . $orderId);
                return response()->json(['message' => 'ID pesanan tidak valid'], 400);
            }

            $order = Order::find($orderId);

            if (!$order) {
                Log::error('ID pesanan tidak ditemukan: ' . $orderId);
                return response()->json(['message' => 'Pesanan tidak ditemukan'], 404);
            }
            switch ($transactionStatus) {
                case 'capture':
                    $order->transaction_status = ($fraudStatus == 'accept') ? 'success' : 'challenge';
                    break;
                case 'settlement':
                    $order->transaction_status = 'settlement';
                    break;
                case 'pending':
                    $order->transaction_status = 'pending';
                    break;
                case 'deny':
                case 'expire':
                case 'cancel':
                    $order->transaction_status = $transactionStatus;
                    $order->status = 'canceled';
                    $order->snap_token = null;
                    break;
                default:
                    Log::error('Status transaksi tidak diketahui: ' . $transactionStatus);
                    return response()->json(['message' => 'Status transaksi tidak diketahui'], 400);
            }

            if ($paymentType) {
                $order->payment_method = $paymentType;
            }

            $order->save();

            if (!$transactionId || !$grossAmount || !$paymentType || !$transactionTime) {
                return response()->json(['message' => 'Rincian transaksi tidak valid'], 400);
            }

            Payment::updateOrCreate(
                ['order_id' => $order->id],
                [
                    'transaction_id' => $transactionId,
                    'amount' => $grossAmount,
                    'payment_method' => $paymentType,
                    'payment_status' => $transactionStatus,
                    'payment_code' => $paymentCode,
                    'transaction_date' => $transactionTime,
                ]
            );

            Log::info("Status pesanan berhasil diperbarui untuk ID Pesanan: $orderId");

            return response()->json(['message' => 'Notifikasi berhasil diproses'], 200);
        } catch (\Exception $e) {
            Log::error('Gagal menangani notifikasi: ' . $e->getMessage());
            return response()->json(['message' => 'Gagal menangani notifikasi'], 500);
        }
    }

    public function getTotalPendapatan()
    {
        $total = DB::table('payments')->sum('total');
        return response()->json(['total' => $total]);
    }
}
