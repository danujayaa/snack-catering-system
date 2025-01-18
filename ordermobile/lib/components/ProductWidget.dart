import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatelessWidget {
  final String title;
  final double price;
  final String image;

  const ProductWidget({
    super.key,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final formatHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;

      double imageHeight = screenWidth * 0.25;

      double fontSizeTitle = screenWidth * 0.04;
      double fontSizePriceTitle = screenWidth * 0.035;

      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.grey.shade200,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: image.isNotEmpty &&
                            Uri.tryParse(image)?.isAbsolute == true
                        ? Image.network(
                            image,
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff3d3d3d),
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  formatHarga.format(price),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: fontSizePriceTitle,
                      color: const Color(0xff7F714F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
