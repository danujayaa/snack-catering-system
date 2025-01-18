import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/controller/FetchDataCart.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/model/Product.dart';

class CartItem extends StatelessWidget {
  final FetchDataCart fetchDataCart;
  final FetchDataProduct fetchDataProduct;
  const CartItem({super.key, required this.fetchDataCart, required this.fetchDataProduct});

  @override
  Widget build(BuildContext context) {
    final formatHarga = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
    return Obx(() {
      if (fetchDataCart.isError.value) {
        return Center(
            child: Text('Error: ${fetchDataCart.errorMessage.value}'));
      }
      if (fetchDataCart.cart.isEmpty) {
        return Center(
            child: Text(
          'Keranjang kosong',
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Color(0xff3d3d3d), fontWeight: FontWeight.w500)),
        ));
      }
      return SingleChildScrollView(
        child: Column(
          children: fetchDataCart.cart.map((item) {
            var product = fetchDataProduct.products.firstWhere(
              (prod) => prod.id == item.productId,
              orElse: () => Product(
                id: 0,
                name: '',
                description: '',
                price: 0,
                categoryId: 0,
                image: '',
              ),
            );

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  ClipRRect(
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF3D3D3D),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatHarga.format(product.price),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF3D3D3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Jumlah: ${item.jumlah}',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF3D3D3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/icon/trash.svg'),
                    onPressed: () => fetchDataCart.deleteCartItem(item.id),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
