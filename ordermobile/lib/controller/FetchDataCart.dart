import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordermobile/model/Cart.dart';
import 'package:ordermobile/service/AuthService.dart';
import 'package:http/http.dart' as http;

class FetchDataCart extends GetxController {
  var cart = <Cart>[].obs;
  var totalHarga = 0.0.obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.soexma.com/api';
  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  Future<void> fetchCart() async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        cart.value = data.map((item) => Cart.fromJson(item)).toList();
        hitungTotalHarga();
      } else {
        isError(true);
        errorMessage('Gagal Memuat item keranjang');
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCart(int productId, int jumlah) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product_id': productId,
          'jumlah': jumlah,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Berhasil memasukkan produk ke keranjang',
            backgroundColor: Colors.green, colorText: Colors.white);
        fetchCart();
      } else {
        Get.snackbar('Gagal', 'Gagal memasukkan produk ke dalam keranjang',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$cartId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        cart.removeWhere((item) => item.id == cartId);
        await fetchCart();
        Get.snackbar('Sukses', 'Item keranjang berhasil dihapus',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Gagal menghapus item keranjang',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  void hitungTotalHarga() {
    totalHarga.value =
        cart.fold(0, (sum, item) => sum + (item.productPrice * item.jumlah));
  }
}
