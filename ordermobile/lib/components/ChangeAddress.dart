import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataAddress.dart';

class ChangeAddress extends StatelessWidget {
  final FetchDataAddress fetchDataAddress = Get.put(FetchDataAddress());

  ChangeAddress({super.key});

  @override
  Widget build(BuildContext context) {
    fetchDataAddress.fetchAddress();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeTitle = screenWidth * 0.045;
    double fontSizeSubtitle = screenWidth * 0.035;
    double padding = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Pilih Alamat',
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
        if (fetchDataAddress.isError.value) {
          return Center(
            child: Text('Error : ${fetchDataAddress.errorMessage.value}'),
          );
        }
        if (fetchDataAddress.addresses.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada alamat',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color(0xff3d3d3d),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children:
                    List.generate(fetchDataAddress.addresses.length, (index) {
                  var address = fetchDataAddress.addresses[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: ListTile(
                      title: Text(
                        '${address.label} - ${address.penerima}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: const Color(0xff3d3d3d),
                            fontSize: fontSizeTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        '${address.alamat}, ${address.kecamatan}, ${address.kabupaten}, ${address.kodepos}\nTelp: ${address.phone}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: const Color(0xFF3D3D3D),
                            fontSize: fontSizeSubtitle,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      onTap: () {
                        fetchDataAddress.defaultAddress(address.id);
                        fetchDataAddress.fetchAddress();
                        Get.back();
                      },
                      trailing: address.defaultAddress == true
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : null,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
