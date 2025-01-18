import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/controller/FetchDataCart.dart';
import 'package:ordermobile/model/Product.dart';

class DetailProduct extends StatefulWidget {
  final Product product = Get.arguments;

  DetailProduct({super.key});

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int jumlah = 30;
  final FetchDataCart fetchDataCart = Get.put(FetchDataCart());

  String _formatPrice(double price) {
    final formatHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatHarga.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double imageWidth = screenWidth * 0.9;
    double imageHeight = screenWidth * 0.6;
    double fontSizeTitle = screenWidth * 0.05;
    double fontSizePrice = screenWidth * 0.04;
    double fontSizeDescription = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Detail Produk",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product.image,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.name,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color(0xff3d3d3d),
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _formatPrice(widget.product.price),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color(0xff3d3d3d),
                      fontSize: fontSizePrice,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Deskripsi",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: const Color(0xff3d3d3d),
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.product.description,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: const Color(0xff3d3d3d),
                  fontSize: fontSizeDescription,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (jumlah > 1) {
                      setState(() {
                        jumlah--;
                      });
                    }
                  },
                  icon: SvgPicture.asset('assets/icon/min.svg'),
                ),
                Text(
                  jumlah.toString(),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xff3d3d3d),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      jumlah++;
                    });
                  },
                  icon: SvgPicture.asset('assets/icon/plus.svg'),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      fetchDataCart.addCart(widget.product.id, jumlah);
                    },
                    child: Text(
                      "Keranjang",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7F714F),
                      minimumSize: Size(screenWidth * 0.5, 40),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
