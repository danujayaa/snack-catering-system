<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{

    public function __construct()
    {
        $this->middleware('auth:sanctum')->except(['register', 'login']);
    }

    public function register(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|min:10|max:15|unique:users',
            'password' => 'required|string|min:8',
            'role' => 'required|string|in:user,superadmin,admin',
        ]);

        $allowedRoles = ['user', 'admin', 'superadmin'];
        $role = in_array($validatedData['role'], $allowedRoles) ? $validatedData['role'] : 'user';

        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'phone' => $validatedData['phone'],
            'password' => Hash::make($validatedData['password']),
            'role' => $role,
        ]);

        return response()->json([
            'user' => $user,
            'message' => 'User berhasil daftar'
        ], 200);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email_or_phone' => 'required|string',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email_or_phone)
            ->orWhere('phone', $request->email_or_phone)
            ->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email_or_phone' => ['Kredensial yang diberikan salah.'],
            ]);
        }

        $token = $user->createToken('user-token', [$user->role])->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }

    public function logout(Request $request)
    {
        $user = $request->user();
        $user->tokens()->delete();

        return response()->json(['message' => 'Berhasil Keluar'], 200);
    }

    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }

    public function update(Request $request, $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        $currentUser = auth()->user();
        $validatedData = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $id,
            'phone' => 'nullable|string|min:10|max:15|unique:users,phone,' . $id,
            'password' => 'sometimes|string|min:8',
        ]);

        if ($currentUser->role === 'superadmin' && $request->has('role')) {
            if ($request->role !== $user->role) {
                return response()->json(['message' => 'Anda tidak dapat mengubah role pengguna'], 403);
            }
        } elseif ($request->has('role')) {
            return response()->json(['message' => 'Role tidak dapat diubah'], 403);
        }
        if ($request->has('name')) {
            $user->name = $validatedData['name'];
        }
        if ($request->has('email')) {
            $user->email = $validatedData['email'];
        }
        if ($request->has('phone')) {
            $user->phone = $validatedData['phone'];
        }
        if ($request->has('password')) {
            $user->password = Hash::make($validatedData['password']);
        }

        $user->save();

        return response()->json([
            'message' => 'User berhasil diperbarui',
            'user' => $user,
        ]);
    }

    public function destroy($id)
    {
        $user = User::find($id);
        
        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        if (auth()->user()->role !== 'superadmin') {
            return response()->json(['message' => 'Anda tidak memiliki izin untuk menghapus pengguna ini'], 403);
        }

        $user->delete();

        return response()->json(['message' => 'User berhasil dihapus']);
    }
}
