import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/routes/route_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DateTime? lastPressed;

  bool _katasandi = true;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null ||
        now.difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = now;
      _showCustomSnackBar();
      return false;
    }
    if (Platform.isAndroid) {
      exit(0);
    }
    return true;
  }

  void _showCustomSnackBar() {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50,
        left: MediaQuery.of(context).size.width / 5,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Tekan lagi untuk keluar aplikasi',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _toggleKatasandi() {
    setState(() {
      _katasandi = !_katasandi;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.32, horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Masuk",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: const Color(0xff3d3d3d),
                            fontSize: screenWidth * 0.15,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email Atau Nomor Handphone",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: const Color(0xff3d3d3d),
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: SizedBox(
                      width: screenWidth,
                      height: 40,
                      child: TextFormField(
                        controller: emailOrPhoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Kata Sandi",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: const Color(0xff3d3d3d),
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: SizedBox(
                      width: screenWidth,
                      height: 40,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _katasandi,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          suffixIcon: IconButton(
                            onPressed: _toggleKatasandi,
                            icon: Icon(
                              _katasandi
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xff3d3d3d),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Obx(() {
                      return authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (emailOrPhoneController.text.isEmpty) {
                                  Get.snackbar('Form',
                                      'Email atau Nomor Handphone harus diisi',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white);
                                  return;
                                }
                                if (passwordController.text.isEmpty) {
                                  Get.snackbar('Form', 'Kata Sandi harus diisi',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white);
                                  return;
                                }
                                authController.login(
                                    emailOrPhoneController.text,
                                    passwordController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff7F714F),
                                minimumSize: Size(screenWidth * 0.55, 45),
                              ),
                              child: Text(
                                "Masuk",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: const Color(0xffFFFFFF),
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: const Color(0xff3d3d3d),
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400)),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.registerscreen);
                        },
                        child: Text("Daftar.",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: const Color(0xffA07656),
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w400))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
