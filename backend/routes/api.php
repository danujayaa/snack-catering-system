<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\AddressController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::post('payments/notification', [PaymentController::class, 'notificationHandler'])->withoutMiddleware('auth:sanctum');

Route::middleware('auth:sanctum')->group(function () {
    // User
    Route::get('users', [AuthController::class, 'index']);
    Route::put('users/{id}', [AuthController::class, 'update']);
    Route::delete('users/{id}', [AuthController::class, 'destroy']);

    // Kategori
    Route::get('categories', [CategoryController::class, 'index']);
    Route::post('categories', [CategoryController::class, 'store']);
    Route::put('categories/{id}', [CategoryController::class, 'update']);
    Route::delete('categories/{id}', [CategoryController::class, 'destroy']);

    // Produk
    Route::get('products', [ProductController::class, 'index']);
    Route::post('products', [ProductController::class, 'store']);
    Route::put('products/{id}', [ProductController::class, 'update']);
    Route::delete('products/{id}', [ProductController::class, 'destroy']);
    Route::get('search', [ProductController::class, 'search']);

    // Alamat
    Route::get('addresses', [AddressController::class, 'index']);
    Route::get('default-address', [AddressController::class, 'getDefaultAddress']);
    Route::post('addresses', [AddressController::class, 'store']);
    Route::put('addresses/{id}', [AddressController::class, 'update']);
    Route::delete('addresses/{id}', [AddressController::class, 'destroy']);
    Route::post('set-default-address/{id}', [AddressController::class, 'setDefaultAddress']);

    // Keranjang
    Route::get('cart', [CartController::class, 'index']);
    Route::post('cart', [CartController::class, 'store']);
    Route::put('cart/{cart}', [CartController::class, 'update']);
    Route::delete('cart/{cart}', [CartController::class, 'destroy']);

    // Pesanan
    Route::get('orders', [OrderController::class, 'index']);
    Route::post('orders', [OrderController::class, 'store']);
    Route::post('orders/{id}/status', [OrderController::class, 'updateStatus']);
    Route::post('orders/{id}/cancel', [OrderController::class, 'cancelOrder']);
    Route::get('top-product', [OrderController::class, 'topProductOrders']);
    Route::get('orders/search', [OrderController::class, 'search']);

    // Pembayaran
    Route::get('payments', [PaymentController::class, 'index']);
    Route::get('payments/search', [PaymentController::class, 'search']);
    Route::get('total-pendapatan', [PaymentController::class, 'getTotalPendapatan']);
});
