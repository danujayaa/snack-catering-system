import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/model/User.dart';
import 'package:ordermobile/service/AuthService.dart';
import 'package:http/http.dart' as http;

class FetchDataUser extends GetxController {
  var users = <User>[].obs;
  var user =
      User(id: 0, name: '', email: '', phone: '', password: '', role: '').obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.soexma.com/api';
  final AuthService authService = Get.find<AuthService>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    fetchUser();
    super.onInit();
  }

  Future<void> fetchUserLogin() async {
    final token = await authService.getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData != null && responseData is Map<String, dynamic>) {
          user.value = User.fromJson(responseData);
        } else {
          isError(true);
          errorMessage('Data pengguna tidak valid');
        }
      } else {
        isError(true);
        errorMessage('Gagal mengambil data pengguna');
      }
    } else {
      isError(true);
      errorMessage('Tidak ada token');
    }
  }

  Future fetchUser() async {
    final token = await authService.getToken();
    isLoading(true);
    isError(false);
    errorMessage('');
    try {
      final responseUsers = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (responseUsers.statusCode == 200) {
        List<dynamic> jsonUsers = json.decode(responseUsers.body);
        users.value = jsonUsers.map((data) => User.fromJson(data)).toList();
      } else {
        isError(true);
        errorMessage('Gagal Memuat Pengguna');
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUser(int id,
      {String? name, String? email, String? phone, String? password}) async {
    final token = await authService.getToken();
    isLoading(true);

    final Map<String, dynamic> body = {};

    if (name != null && name.isNotEmpty) {
      body['name'] = name;
    }
    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    }
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final updateUserData = jsonDecode(response.body)['user'];
        User updateUser = User.fromJson(updateUserData);

        int index = users.indexWhere((user) => user.id == id);
        if (index != -1) {
          users[index] = updateUser;
          users.refresh();
        }

        if (authController.user.value.id == id) {
          authController.user.value = updateUser;
        }

        await fetchUser();

        Get.snackbar('Sukses', 'User berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'User gagal diperbarui',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteUser(int id) async {
    final token = await authService.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == id);
        Get.snackbar('Sukses', 'User berhasil dihapus',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'User gagal dihapus',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  int getTotalUsers() {
    return users.length;
  }
}

class FetchUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FetchDataUser());
  }
}
