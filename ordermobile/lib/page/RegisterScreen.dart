import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/routes/route_name.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _katasandi = true;
  bool _konfirmasi = true;

  void _toggleKatasandi() {
    setState(() {
      _katasandi = !_katasandi;
    });
  }

  void _toggleKonfirmasi() {
    setState(() {
      _konfirmasi = !_konfirmasi;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.19, horizontal: width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Daftar",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: const Color(0xff3d3d3d),
                          fontSize: width * 0.14,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                Text(
                  "Nama Lengkap *",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: const Color(0xff3d3d3d),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    width: width,
                    height: 40,
                    child: TextFormField(
                      controller: nameController,
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
                  "Email *",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: const Color(0xff3d3d3d),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    width: width,
                    height: 40,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "No Handphone *",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: const Color(0xff3d3d3d),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    width: width,
                    height: 40,
                    child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kata Sandi *",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: const Color(0xff3d3d3d),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    width: width,
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
                              ))),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Konfirmasi Kata Sandi *",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: const Color(0xff3d3d3d),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    width: width,
                    height: 40,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _konfirmasi,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          suffixIcon: IconButton(
                              onPressed: _toggleKonfirmasi,
                              icon: Icon(
                                _konfirmasi
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xff3d3d3d),
                              ))),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(child: Obx(() {
                  return authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isEmpty) {
                              Get.snackbar('Form', 'Nama harus diisi',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }
                            if (emailController.text.isEmpty) {
                              Get.snackbar('Form', 'Email harus diisi',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }
                            if (phoneController.text.isEmpty) {
                              Get.snackbar(
                                  'Form', 'Nomor Handphone harus diisi',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }

                            if (passwordController.text.isEmpty) {
                              Get.snackbar('Form', 'Password harus diisi',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }

                            if (passwordController.text.length < 8) {
                              Get.snackbar(
                                  'Peringatan', 'Password minimal 8 karakter',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }

                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              Get.snackbar('Peringatan',
                                  'Konfirmasi kata sandi tidak cocok',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }
                            authController.register(
                                nameController.text,
                                emailController.text,
                                phoneController.text,
                                passwordController.text);
                            nameController.clear();
                            emailController.clear();
                            phoneController.clear();
                            passwordController.clear();
                            confirmPasswordController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff7F714F),
                            minimumSize: Size(width * 0.55, 45),
                          ),
                          child: Text(
                            "Daftar",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: const Color(0xffFFFFFF),
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                })),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun? ",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: const Color(0xff3d3d3d),
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w400)),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteName.loginscreen);
                      },
                      child: Text("Masuk",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: const Color(0xffA07656),
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w400))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
