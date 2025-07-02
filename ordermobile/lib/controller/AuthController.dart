import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ordermobile/model/User.dart';
import 'package:ordermobile/routes/route_name.dart';
import 'package:ordermobile/service/AuthService.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var user =
      User(id: 0, name: '', email: '', phone: '', password: '', role: '').obs;

  final String baseUrl = 'https://yunna.soexma.com/api';
  final AuthService _authService = Get.find<AuthService>();

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': 'user'
        }),
      );

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(RouteName.loginscreen);
        Get.snackbar('Sukses', 'Register Berhasil!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Register Gagal!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Register Gagal: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email_or_phone, String password) async {
    isLoading(true);
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'email_or_phone': email_or_phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('token') &&
          responseData.containsKey('user')) {
        String token = responseData['token'];

        await _authService.saveToken(token);
        await _authService.saveUserData(responseData['user']);
        await Future.delayed(const Duration(seconds: 2));

        isLoggedIn.value = true;
        user.value = User.fromJson(responseData['user']);
        Get.offAllNamed(RouteName.navbar);
        Get.snackbar('Sukses', 'Login Berhasil!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Data login tidak valid',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Login Gagal',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading(false);
  }

  Future<void> logoutConfirm() async {
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          titlePadding:
              const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          actionsPadding: const EdgeInsets.only(bottom: 10.0),
          title: Text(
            'Konfirmasi Keluar',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: const Color(0xff3d3d3d),
                fontSize: screenWidth > 600 ? 20 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: const Color(0xff3d3d3d),
                fontSize: screenWidth > 600 ? 16 : 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            SizedBox(
              width: screenWidth > 600 ? 100 : 80,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff3d3d3d)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Batal',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color(0xff3d3d3d),
                      fontSize: screenWidth > 600 ? 14 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth > 600 ? 100 : 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F714F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  minimumSize: const Size(70, 40),
                ),
                onPressed: () {
                  logout();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ya',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth > 600 ? 14 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await _authService.clearToken();
    isLoggedIn.value = false;
    user.value = User(
      id: 0,
      name: '',
      email: '',
      phone: '',
      password: '',
      role: '',
    );
    Get.offAllNamed(RouteName.loginscreen);
    Get.snackbar('Sukses', 'Berhasil Keluar!',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  Future<void> checkLoginStatus() async {
    String? token = await _authService.getToken();
    if (token != null) {
      var userData = await _authService.getUserData();
      if (userData != null) {
        user.value = User.fromJson(userData);
      }
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }
}
