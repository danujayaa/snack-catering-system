import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordermobile/model/Address.dart';
import 'package:ordermobile/service/AuthService.dart';
import 'package:http/http.dart' as http;

class FetchDataAddress extends GetxController {
  var addresses = <Address>[].obs;
  var userAddress = <Address>[].obs;
  var setAddress = 0.obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.bwa.biz.id/api';
  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    fetchAddress();
    super.onInit();
  }

  Future<void> fetchAddress() async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/addresses'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonAddresses = json.decode(response.body);
        addresses.value =
            jsonAddresses.map((data) => Address.fromJson(data)).toList();
      } else {
        isError(true);
        errorMessage(
            'Gagal Memuat Alamat. Status code: ${response.statusCode}');
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> defaultAddress(int id) async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/set-default-address/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setAddress.value = id;
        Get.snackbar('Sukses', 'Alamat berhasil diatur',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Gagal mengatur alamat',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<Address?> getdefaultAddress() async {
    final token = await authService.getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/default-address'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> addressJson = json.decode(response.body);
        return Address.fromJson(addressJson);
      } else {
        isError(true);
        errorMessage('Gagal mendapatkan alamat default');
        return null;
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
      return null;
    }
  }

  Future<void> addAddress(Address address) async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addresses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(address.toJson()),
      );

      if (response.statusCode == 201) {
        Address newAddress = Address.fromJson(json.decode(response.body));
        addresses.add(newAddress);
        Get.snackbar('Sukses', 'Alamat berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Gagal menambahkan alamat',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateAddress(Address address) async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/addresses/${address.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(address.toJson()),
      );

      if (response.statusCode == 200) {
        addresses.value =
            addresses.map((a) => a.id == address.id ? address : a).toList();
        Get.snackbar('Sukses', 'Alamat berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Gagal memperbarui alamat',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAddress(int id) async {
    final token = await authService.getToken();
    isLoading(true);
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/addresses/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        addresses.removeWhere((address) => address.id == id);
        Get.snackbar('Sukses', 'Alamat berhasil dihapus',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchAddress();
      } else {
        Get.snackbar('Gagal', 'Gagal menghapus alamat',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }
}
