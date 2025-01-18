import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ordermobile/model/Payment.dart';
import 'package:ordermobile/service/AuthService.dart';

class FetchDataPayment extends GetxController {
  var payments = <Payment>[].obs;
  var totalPendapatan = 0.0.obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.bwa.biz.id/api';
  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    fetchPayment();
    fetchFinanceData();
    super.onInit();
  }

  Future<void> fetchPayment() async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        payments.value = data.map((json) => Payment.fromJson(json)).toList();
      } else {
        isError(true);
        errorMessage('Gagal memuat pembayaran');
      }
    } catch (e) {
      isError(true);
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSearchPayment(String query) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/search?query=$query'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> paymentsJson = jsonDecode(response.body)['data'];
        payments.value =
            paymentsJson.map((json) => Payment.fromJson(json)).toList();
      } else {
        isError(true);
        errorMessage.value = 'Pencarian gagal';
        await fetchPayment();
      }
    } catch (e) {
      isError(true);
      errorMessage.value = e.toString();
      await fetchPayment();
    } finally {
      isLoading(false);
    }
  }

  Future<void> handlePaymentNotif(Map<String, dynamic> notificationData) async {
    final token = await authService.getToken();
    if (notificationData['order_id'] == null ||
        notificationData['order_id'].toString().isEmpty) {
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/notification'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
      } else {
        isError(true);
        errorMessage('Gagal mengirim notifikasi');
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi kesalahan: $e');
    }
  }

  Future<void> fetchFinanceData() async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/total-pendapatan'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        totalPendapatan.value = double.parse(jsonResponse['total']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      isError(true);
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
