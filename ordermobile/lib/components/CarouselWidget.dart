import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselWidget extends StatelessWidget {
  final FetchDataProduct fetchDataProduct = Get.put(FetchDataProduct());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth * 0.06;

    return Obx(() {
      if (fetchDataProduct.isError.value) {
        return const SizedBox(height: 200);
      } else if (fetchDataProduct.products.isEmpty) {
        return const SizedBox(height: 200);
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: CarouselSlider.builder(
            itemCount: fetchDataProduct.products.length,
            itemBuilder: (context, index, realIndex) {
              final product = fetchDataProduct.products[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        product.image,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight * 0.02,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: screenHeight * 0.25,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: true,
              viewportFraction: screenWidth < 400 ? 0.9 : 0.85,
            ),
          ),
        );
      }
    });
  }
}
