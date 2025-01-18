import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Tentang',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tentang Aplikasi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Aplikasi ini dirancang untuk memudahkan pengguna dalam memesan makanan dan catering secara online. Dengan antarmuka yang intuitif dan fitur yang lengkap, pengguna dapat menjelajahi berbagai pilihan makanan, membuat pesanan, dan melakukan pembayaran dengan mudah.',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'Fitur Utama:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                '- Menjelajahi berbagai kategori makanan\n'
                '- Membuat dan mengelola pesanan\n'
                '- Pembayaran yang aman dan mudah\n'
                '- Melacak status pesanan',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'Tentang Pengembang',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                'Aplikasi ini dikembangkan oleh Tim Yunna Snack & Catering, yang berkomitmen untuk memberikan pengalaman pemesanan makanan terbaik bagi pengguna. Kami selalu terbuka untuk saran dan masukan dari pengguna.',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'Kontak:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                'Email: danujaya516@gmail.com\n'
                'Telepon: +62 822 435 86407',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
