import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/controller/FetchDataUser.dart';
import 'package:ordermobile/model/User.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final FetchDataUser fetchDataUser = Get.find<FetchDataUser>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _katasandi = true;
  bool _confirmKatasandi = true;

  void _toggleKatasandi() {
    setState(() {
      _katasandi = !_katasandi;
    });
  }

  void _toggleConfirmKatasandi() {
    setState(() {
      _confirmKatasandi = !_confirmKatasandi;
    });
  }

  bool _formChanged(User user) {
    return nameController.text != user.name ||
        emailController.text != user.email ||
        phoneController.text != user.phone ||
        passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    final User user = Get.arguments ?? authController.user.value;
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final User user = Get.arguments ?? authController.user.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (fetchDataUser.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (fetchDataUser.isError.value) {
          return Center(
              child: Text('Error: ${fetchDataUser.errorMessage.value}'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              children: [
                Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff7F714F),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'P',
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff7F714F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: nameController,
                  hintText: user.name,
                  label: "Nama Lengkap",
                  icon: Icons.person,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: emailController,
                  hintText: user.email,
                  label: "Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: phoneController,
                  hintText: user.phone,
                  label: "No. Handphone",
                  icon: Icons.phone,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Kata Sandi Baru',
                  label: "Kata Sandi",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: confirmPasswordController,
                  hintText: 'Konfirmasi Kata Sandi',
                  label: "Konfirmasi Kata Sandi",
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _formChanged(user)
                      ? () {
                          if (_validateForm()) {
                            fetchDataUser.updateUser(
                              user.id,
                              name: nameController.text.isNotEmpty
                                  ? nameController.text
                                  : user.name,
                              email: emailController.text.isNotEmpty
                                  ? emailController.text
                                  : user.email,
                              phone: phoneController.text.isNotEmpty
                                  ? phoneController.text
                                  : user.phone,
                              password: passwordController.text.isNotEmpty
                                  ? passwordController.text
                                  : null,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7F714F),
                    minimumSize: Size(width * 0.55, 45),
                  ),
                  child: Text(
                    'Update Profile',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(color: Colors.white),
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? (controller == passwordController ? _katasandi : _confirmKatasandi)
          : false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xff7F714F)),
        hintText: hintText,
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Color(0xff3d3d3d),
            fontWeight: FontWeight.w500,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff7F714F), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff7F714F), width: 1.5),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: isPassword
                    ? (controller == passwordController
                        ? _toggleKatasandi
                        : _toggleConfirmKatasandi)
                    : null,
                icon: Icon(
                  isPassword
                      ? (controller == passwordController
                          ? (_katasandi
                              ? Icons.visibility_off
                              : Icons.visibility)
                          : (_confirmKatasandi
                              ? Icons.visibility_off
                              : Icons.visibility))
                      : Icons.visibility,
                  color: const Color(0xff3d3d3d),
                ),
              )
            : null,
      ),
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          color: Color(0xff3d3d3d),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _validateForm() {
    if (passwordController.text.isNotEmpty &&
        passwordController.text.length < 8) {
      Get.snackbar("Peringatan", "Password harus minimal 8 karakter",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Peringatan", "Konfirmasi kata sandi tidak cocok",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }
}
