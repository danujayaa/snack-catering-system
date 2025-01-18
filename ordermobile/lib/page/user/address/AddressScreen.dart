import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataAddress.dart';
import 'package:ordermobile/model/Address.dart';
import 'package:ordermobile/routes/route_name.dart';

class AddressScreen extends StatelessWidget {
  final FetchDataAddress fetchDataAddress = Get.put(FetchDataAddress());

  AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Alamat Pengiriman',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.05),
            child: SizedBox(
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed(RouteName.addalamat);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.add, color: Color(0xff3d3d3d)),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (fetchDataAddress.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Color(0xff7F714F)),
                const SizedBox(height: 16),
                Text(
                  'Memuat alamat...',
                  style: GoogleFonts.poppins(
                    color: const Color(0xff3d3d3d),
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          );
        }
        if (fetchDataAddress.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Error : ${fetchDataAddress.errorMessage.value}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xff3d3d3d),
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          );
        }
        if (fetchDataAddress.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/img/address.svg',
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada alamat pengiriman',
                  style: GoogleFonts.poppins(
                    color: const Color(0xff3d3d3d),
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: fetchDataAddress.addresses.length,
          separatorBuilder: (context, index) => const Divider(thickness: 1),
          itemBuilder: (context, index) {
            Address address = fetchDataAddress.addresses[index];
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    address.label,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: const Color(0xff3d3d3d),
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xff3d3d3d),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(RouteName.editalamat, arguments: address);
                      } else if (value == 'hapus') {
                        fetchDataAddress.deleteAddress(address.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'hapus',
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Text(
                '${address.penerima}, ${address.alamat}, ${address.kecamatan}, ${address.kabupaten}, ${address.kodepos}, ${address.phone}',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: const Color(0xff3d3d3d),
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
