<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index()
    {
        $product = Product::all();
        return response()->json($product);
    }

    public function search(Request $request)
    {
        $query = $request->input('query');

        if (empty($query)) {
            return response()->json(['message' => 'Query tidak boleh kosong'], 400);
        }

        $products = Product::whereRaw('LOWER(name) LIKE ?', ["%" . strtolower($query) . "%"])->get();

        if ($products->isEmpty()) {
            return response()->json(['message' => 'Produk Tidak Ada'], 404);
        }

        return response()->json($products);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric',
            'category_id' => 'required|exists:categories,id',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('product_images', 'public');
            $imageUrl = Storage::url($imagePath);
            $validatedData['image'] = $imageUrl;
        }

        $product = Product::create($validatedData);

        return response()->json([
            'message' => 'Produk Baru Berhasil Ditambah!',
            'product' => $product
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'category_id' => 'required|exists:categories,id',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($request->input('image') === 'null') {
            $validatedData['image'] = $product->image;
        } elseif ($request->hasFile('image')) {
            if ($product->image && !filter_var($product->image, FILTER_VALIDATE_URL)) {
                $imagePath = str_replace('/storage/', '', $product->image);
                Storage::disk('public')->delete($imagePath);
            }
            $imagePath = $request->file('image')->store('product_images', 'public');
            $imageUrl = Storage::url($imagePath);
            $validatedData['image'] = $imageUrl;
        }

        $product->update($validatedData);

        $product = $product->fresh();

        return response()->json(['message' => 'Produk berhasil diperbarui', 'product' => $product, 'image_url' => $product->image]);
    }

    public function destroy($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json(['message' => 'Produk tidak ditemukan!'], 404);
        }

        if ($product->image && !filter_var($product->image, FILTER_VALIDATE_URL)) {
            $imagePath = str_replace('/storage/', '', $product->image);
            Storage::disk('public')->delete($imagePath);
        }

        $product->delete();

        return response()->json([
            'message' => 'Produk Berhasil Dihapus!'
        ], 200);
    }
}
