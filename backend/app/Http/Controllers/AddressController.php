<?php

namespace App\Http\Controllers;

use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class AddressController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index()
    {
        $user = Auth::user();

        if ($user->role === 'superadmin' || $user->role === 'admin') {
            $addresses = Address::all();
        } else {
            $addresses = Address::where('user_id', $user->id)->get();
        }

        return response()->json($addresses);
    }

    public function getDefaultAddress()
    {
        $user = Auth::user();
        $defaultAddress = Address::where('user_id', $user->id)->where('default', true)->first();

        if ($defaultAddress) {
            return response()->json($defaultAddress, 200);
        } else {
            return response()->json(['message' => 'Alamat default tidak ditemukan.'], 404);
        }
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:100',
            'penerima' => 'required|string|max:255',
            'alamat_lengkap' => 'required|string|max:255',
            'kecamatan' => 'required|string|max:100',
            'kabupaten' => 'required|string|max:100',
            'kode_pos' => 'required|string|max:10',
            'phone' => 'required|string|max:15',
            'default' => 'nullable|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $address = new Address($request->all());
        $address->user_id = Auth::id();
        $address->save();

        return response()->json($address, 201);
    }

    public function update(Request $request, $id)
    {
        $address = Address::findOrFail($id);
        $user = Auth::user();

        if ($user->id !== $address->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:100',
            'penerima' => 'required|string|max:255',
            'alamat_lengkap' => 'required|string|max:255',
            'kecamatan' => 'required|string|max:100',
            'kabupaten' => 'required|string|max:100',
            'kode_pos' => 'required|string|max:10',
            'phone' => 'required|string|max:15',
            'default' => 'nullable|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        $address->update($validator->validated());

        return response()->json(['message' => 'Alamat berhasil diperbarui', 'address' => $address], 200);
    }

    public function destroy($id)
    {
        $address = Address::findOrFail($id);
        if ($address && $address->user_id === auth()->user()->id) {
            $address->delete();
            return response()->json(['message' => 'Alamat berhasil dihapus']);
        }

        return response()->json(['message' => 'Unauthorized'], 403);
    }

    public function setDefaultAddress($id)
    {
        $user = Auth::user();
        Address::where('user_id', $user->id)->update(['default' => false]);
        $address = Address::where('user_id', $user->id)->where('id', $id)->firstOrFail();
        $address->default = true;
        $address->save();

        return response()->json(['message' => 'Alamat default berhasil diatur'], 200);
    }
}
