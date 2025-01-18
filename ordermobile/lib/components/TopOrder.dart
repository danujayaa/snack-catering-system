import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';

class TopProductOrdersCustomScreen extends StatelessWidget {
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());

  TopProductOrdersCustomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final paddingHorizontal = screenWidth * 0.025;
    final paddingVertical = screenHeight * 0.01;
    final fontSizeTitle = screenWidth * 0.045;
    final fontSizeSubtitle = screenWidth * 0.035;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top 5 Produk',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: const Color(0xff3d3d3d),
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w600)),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (fetchDataOrder.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (fetchDataOrder.isError.value) {
          return Center(child: Text(fetchDataOrder.errorMessage.value));
        } else if (fetchDataOrder.topProduct.isEmpty) {
          return const Center(child: Text('Tidak ada data produk'));
        } else {
          var topProducts = fetchDataOrder.topProduct.take(5).toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: ListView.builder(
              itemCount: topProducts.length,
              itemBuilder: (context, index) {
                var product = topProducts[index];

                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal, vertical: paddingVertical),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.productImage,
                          width: screenWidth * 0.14,
                          height: screenWidth * 0.14,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: fontSizeSubtitle,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Text(
                        'Total: ${product.totalQuantity}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: fontSizeSubtitle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
