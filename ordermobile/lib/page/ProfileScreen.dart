import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/routes/route_name.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double padding = screenWidth * 0.05;
    final double headerPadding = screenHeight * 0.08;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(screenWidth, padding, headerPadding),
                  _buildProfileSection(padding, screenWidth),
                ],
              ),
            ),
          ),
          _buildLogoutButton(screenWidth),
        ],
      ),
    );
  }

  Widget _buildHeader(
      double screenWidth, double padding, double headerPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, headerPadding, padding, 30),
      child: Column(
        children: [
          Obx(() {
            final userName = authController.isLoggedIn.value
                ? authController.user.value.name
                : 'Pengguna Tidak Terdaftar';

            return Column(
              children: [
                Container(
                  width: screenWidth * 0.85,
                  height: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff7F714F),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'P',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.09,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff7F714F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2D2D2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authController.user.value.role == 'user'
                      ? "Pelanggan"
                      : authController.user.value.role == 'admin'
                          ? "Admin"
                          : "Super Admin",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: const Color(0xff7F714F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfileSection(double padding, double screenWidth) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (authController.user.value.role == 'user' ||
              authController.user.value.role == 'admin') ...[
            _buildSectionTitle("Akun", screenWidth),
            const SizedBox(height: 10),
            _buildMenuItems([
              _buildMenuItem(
                "Edit Profile",
                screenWidth,
                onTap: () => Get.toNamed(RouteName.editprofile),
              ),
              if (authController.user.value.role == 'user')
                _buildMenuItem(
                  "Alamat Pengiriman",
                  screenWidth,
                  onTap: () => Get.toNamed(RouteName.alamatpengiriman),
                ),
            ]),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle("Lainnya", screenWidth),
          const SizedBox(height: 10),
          _buildMenuItems([
            _buildMenuItem(
              "Tentang",
              screenWidth,
              onTap: () => Get.toNamed(RouteName.tentang),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.w600,
        color: const Color(0xff7F714F),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMenuItems(List<Widget> items) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final item = entry.value;
        return Column(
          children: [
            item,
            const Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(String title, double screenWidth,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: const Color(0xff3d3d3d),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xff3d3d3d),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(double screenWidth) {
    return TextButton(
      onPressed: () => authController.logoutConfirm(),
      style: TextButton.styleFrom(
          foregroundColor: const Color(0xff3d3d3d),
          padding: const EdgeInsets.symmetric(vertical: 20)),
      child: SizedBox(
        width: screenWidth * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Keluar",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
