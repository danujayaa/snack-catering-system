import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataAddress.dart';
import 'package:ordermobile/model/Address.dart';

class AddAddress extends StatelessWidget {
  final FetchDataAddress fetchDataAddress = Get.put(FetchDataAddress());
  final labelController = TextEditingController();
  final penerimaController = TextEditingController();
  final alamatController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kabupatenController = TextEditingController();
  final kodeposController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Tambah Alamat Pengiriman',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        controller: labelController,
                        label: 'Label',
                        hint: 'Contoh: Rumah/Kantor',
                        icon: Icons.home_rounded,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: penerimaController,
                        label: 'Penerima',
                        hint: 'Nama Lengkap Penerima',
                        icon: Icons.person_outline,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: alamatController,
                        label: 'Alamat',
                        hint: 'Alamat Lengkap',
                        icon: Icons.home_outlined,
                        maxLines: 3,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: kecamatanController,
                              label: 'Kecamatan',
                              hint: 'Kecamatan',
                              icon: Icons.location_city_outlined,
                              screenWidth: screenWidth,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildTextField(
                              controller: kabupatenController,
                              label: 'Kabupaten/Kota',
                              hint: 'Kabupaten/Kota',
                              icon: Icons.location_on_outlined,
                              screenWidth: screenWidth,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: kodeposController,
                              label: 'Kode Pos',
                              hint: 'Kode Pos',
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.number,
                              screenWidth: screenWidth,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildTextField(
                              controller: phoneController,
                              label: 'Nomor HP',
                              hint: 'Nomor HP',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              screenWidth: screenWidth,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              _buildSubmitButton(screenWidth: screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required double screenWidth,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xff7F714F)),
          labelStyle: GoogleFonts.poppins(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff7F714F), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 15, horizontal: screenWidth * 0.04),
        ),
      ),
    );
  }

  Widget _buildSubmitButton({required double screenWidth}) {
    return ElevatedButton(
      onPressed: () {
        if (_validateForm()) {
          Address newAddress = Address(
            id: 0,
            userId: 1,
            label: labelController.text,
            penerima: penerimaController.text,
            alamat: alamatController.text,
            kecamatan: kecamatanController.text,
            kabupaten: kabupatenController.text,
            kodepos: kodeposController.text,
            phone: phoneController.text,
            defaultAddress: false,
          );
          fetchDataAddress.addAddress(newAddress);
          Get.back();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff7F714F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        elevation: 5,
        minimumSize: Size(screenWidth * 0.9, 40),
      ),
      child: Text(
        'Tambah Alamat',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (labelController.text.isEmpty ||
        penerimaController.text.isEmpty ||
        alamatController.text.isEmpty ||
        kecamatanController.text.isEmpty ||
        kabupatenController.text.isEmpty ||
        kodeposController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Form Tidak Lengkap',
        'Harap lengkapi semua form yang wajib diisi',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }
}
