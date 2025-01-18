import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataUser.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/model/User.dart';
import 'package:ordermobile/routes/route_name.dart';

class UserAdminScreen extends StatelessWidget {
  final FetchDataUser fetchDataUser = Get.find<FetchDataUser>();
  final AuthController authController = Get.find<AuthController>();

  UserAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Pengguna',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (fetchDataUser.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (fetchDataUser.isError.value) {
          return Center(
            child: Text('Error: ${fetchDataUser.errorMessage.value}'),
          );
        } else if (fetchDataUser.users.isEmpty) {
          return Center(
            child: Text(
              'Tidak Ada Data User',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        } else {
          final isSuperAdmin = authController.user.value.role == 'superadmin';
          return UserList(
              fetchDataUser: fetchDataUser,
              users: fetchDataUser.users,
              isSuperAdmin: isSuperAdmin);
        }
      }),
    );
  }
}

class UserList extends StatelessWidget {
  final FetchDataUser fetchDataUser;
  final List<User> users;
  final bool isSuperAdmin;

  const UserList({
    super.key,
    required this.fetchDataUser,
    required this.users,
    required this.isSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserItem(
            user: users[index],
            fetchDataUser: fetchDataUser,
            isSuperAdmin: isSuperAdmin);
      },
    );
  }
}

class UserItem extends StatelessWidget {
  final User user;
  final FetchDataUser fetchDataUser;
  final bool isSuperAdmin;

  const UserItem({
    super.key,
    required this.user,
    required this.fetchDataUser,
    required this.isSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFF4A90E2),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildRoleChip(user.role),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'Email', user.email),
            _buildInfoRow(Icons.phone, 'Nomor Handphone', user.phone),
            if (isSuperAdmin && user.role != 'superadmin') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(
                      'Edit',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF4A90E2),
                    ),
                    onPressed: () {
                      Get.toNamed(
                        RouteName.editprofile,
                        arguments: user,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete, size: 18),
                    label: Text(
                      'Hapus',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => fetchDataUser.deleteUser(user.id),
                  ),
                ],
              ),
            ] else if (user.role == 'superadmin') ...[
              const SizedBox(height: 15),
              Text(
                'Tidak dapat mengedit atau menghapus Superadmin',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color(0xff3d3d3d),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(color: Color(0xff3d3d3d)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color chipColor;
    switch (role.toLowerCase()) {
      case 'superadmin':
        chipColor = Colors.red;
        break;
      case 'admin':
        chipColor = Colors.orange;
        break;
      default:
        chipColor = Colors.green;
    }

    return Chip(
      label: Text(
        role,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: chipColor,
    );
  }
}
