import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordermobile/controller/FetchDataAddress.dart';
import 'package:ordermobile/controller/FetchDataCart.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/controller/FetchDataUser.dart';
import 'package:ordermobile/model/Order.dart';
import 'package:ordermobile/service/AuthService.dart';
import 'package:http/http.dart' as http;

class FetchDataOrder extends GetxController {
  var orders = <Order>[].obs;
  var topProduct = <TopProductOrder>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.soexma.com/api';
  final AuthService authService = Get.find<AuthService>();
  final FetchDataUser fetchDataUser = Get.find<FetchDataUser>();
  final FetchDataAddress fetchDataAddress = Get.put(FetchDataAddress());
  final FetchDataCart fetchDataCart = Get.put(FetchDataCart());
  final FetchDataProduct fetchDataProduct = Get.put(FetchDataProduct());

  @override
  void onInit() {
    super.onInit();
    fetchOrder();
    topProductOrders();
  }

  Future<void> fetchOrder() async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final responseOrders = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (responseOrders.statusCode == 200) {
        final List<dynamic> ordersJson = json.decode(responseOrders.body);
        orders.value =
            ordersJson.map((orderJson) => Order.fromJson(orderJson)).toList();

        await fetchDataProduct.fetchProduct();

      } else {
        throw Exception(
            'Gagal memuat pesanan. Status code: ${responseOrders.statusCode}');
      }
    } catch (e) {
      isError(true);
      errorMessage('Gagal Memuat Pesanan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSearchOrder(String query) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/search?query=$query'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = jsonDecode(response.body)['data'];
        final List<Order> fetchedOrders =
            ordersJson.map((json) => Order.fromJson(json)).toList();

        if (query.isNotEmpty) {
          orders.value = fetchedOrders
              .where((order) => order.id.toString().contains(query))
              .toList();
        } else {
          orders.value = fetchedOrders;
        }
      } else {
        isError(true);
        errorMessage.value = 'Pencarian gagal';
        await fetchOrder();
      }
    } catch (e) {
      isError(true);
      errorMessage.value = e.toString();
      await fetchOrder();
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required DateTime tglPesan,
    required DateTime tglAntar,
    required String jam,
    String? catatan,
    String? paymentMethod,
  }) async {
    final token = await authService.getToken();
    isLoading(true);
    isError(false);

    try {
      final responseOrders = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'tgl_pesan': tglPesan.toIso8601String(),
          'tgl_antar': tglAntar.toIso8601String(),
          'jam': jam,
          'catatan': catatan,
          'payment_method': paymentMethod,
        }),
      );
      print('Status Code: ${responseOrders.statusCode}');
      print('Response Body: ${responseOrders.body}');

      if (responseOrders.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(responseOrders.body);
        return data;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(responseOrders.body);
        isError(true);
        errorMessage('Gagal membuat pesanan: ${errorData['message']}');
        throw Exception('Gagal membuat pesanan: ${errorData['message']}');
      }
    } catch (e) {
      isError(true);
      Get.snackbar('Gagal', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      throw Exception('Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateOrder(int id, String status) async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
        }),
      );
      if (response.statusCode == 200) {
        await fetchOrder();
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        errorMessage(
            'Gagal memperbarui status pesanan: ${errorData['message']}');
      }
    } catch (e) {
      isError(true);
      errorMessage('Gagal Update Status Pesanan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelOrder(int orderId) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Cancel Order Response Status: ${response.statusCode}');
      print('Cancel Order Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Pesanan berhasil dibatalkan',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchOrder();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        Get.snackbar(
          'Gagal',
          'Gagal membatalkan pesanan: ${errorData['message']}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isError(true);
      errorMessage('Gagal membatalkan pesanan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> topProductOrders() async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top-product'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        topProduct.value =
            data.map((item) => TopProductOrder.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      isError(true);
      errorMessage('An error occurred: $e');
      topProduct.clear();
    } finally {
      isLoading(false);
    }
  }

  int getTotalOrders() {
    return orders.length;
  }
}
