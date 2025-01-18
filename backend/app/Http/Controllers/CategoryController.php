<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;


class CategoryController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index()
    {
        $category = Category::all();
        return response()->json($category);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255|unique:categories'
        ]);

        $category = Category::create($validatedData);
        return response()->json([
            'message' => 'Kategori Baru Berhasil Ditambah!',
            'category' => $category
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $category = Category::find($id);

        if (!$category) {
            return response()->json(['message' => 'Kategori Tidak Ada'], 404);
        }

        $validatedData = $request->validate([
            'name' => 'required|string|max:255|unique:categories,name,' . $id,
        ]);

        $category->update($validatedData);

        return response()->json([
            'message' => 'Kategori Berhasil Diperbaharui!',
            'category' => $category
        ], 200);
    }

    public function destroy($id)
    {
        $category = Category::find($id);
        if (!$category) {
            return response()->json(['message' => 'Kategori Tidak Ada'], 404);
        }

        $category->delete();
        return response()->json(['message' => 'Kategori Berhasil Dihapus'], 200);
    }
}
