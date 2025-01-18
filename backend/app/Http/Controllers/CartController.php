<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use Illuminate\Http\Request;

class CartController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $cartItems = Cart::where('user_id', $user->id)->with('product')->get();
        return response()->json($cartItems);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'jumlah' => 'required|integer|min:30',
        ]);

        $cartItem = Cart::create(
            [
                'user_id' => auth()->id(),
                'product_id' => $validated['product_id'],
                'jumlah' => $validated['jumlah']
            ]
        );

        return response()->json(['message' => 'Produk berhasil ditambahkan ke keranjang', 'cartItem' => $cartItem], 200);
    }

    public function destroy($id)
    {
        $cartItem = Cart::where('id', $id)->where('user_id', auth()->id())->firstOrFail();
        $cartItem->delete();

        return response()->json(['message' => 'Barang dihapus dari keranjang'], 200);
    }
}
