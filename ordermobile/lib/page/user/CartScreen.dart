import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/components/CartItem.dart';
import 'package:ordermobile/components/FormShipping.dart';
import 'package:ordermobile/controller/FetchDataAddress.dart';
import 'package:ordermobile/controller/FetchDataCart.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/model/Address.dart';
import 'package:ordermobile/routes/route_name.dart';

class CartScreen extends StatefulWidget {
  final int userId;
  final int addressId;
  final String tglAntar;
  final String jam;
  final String catatan;

  const CartScreen({
    super.key,
    required this.userId,
    required this.addressId,
    required this.tglAntar,
    required this.jam,
    required this.catatan,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FetchDataCart fetchDataCart = Get.put(FetchDataCart());
  final FetchDataAddress fetchDataAddress = Get.put(FetchDataAddress());
  final FetchDataProduct fetchDataProduct = Get.put(FetchDataProduct());
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());

  final TextEditingController waktuantarController = TextEditingController();
  final TextEditingController jamController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  final formatHarga = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    fetchDataCart.fetchCart();
    fetchDataAddress.fetchAddress();
    fetchDataProduct.fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Keranjang',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(screenWidth),
                  CartItem(
                      fetchDataCart: fetchDataCart,
                      fetchDataProduct: fetchDataProduct),
                  const Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  FormShipping(
                    waktuantarController: waktuantarController,
                    jamController: jamController,
                    catatanController: catatanController,
                  ),
                ],
              ),
            ),
          ),
          _buildTotalAndOrderButton(screenWidth),
        ],
      ),
    );
  }

  Widget _buildAddressSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Alamat',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'Ubah',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFFA07656),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(RouteName.ubahalamat);
                },
              ),
            ],
          ),
          Obx(() {
            if (fetchDataAddress.isError.value) {
              return Text('Error: ${fetchDataAddress.errorMessage.value}');
            }
            if (fetchDataAddress.addresses.isEmpty) {
              return Text(
                'Tidak ada alamat',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }
            var setAddress = fetchDataAddress.addresses.firstWhere(
              (address) => address.defaultAddress == true,
              orElse: () => Address(
                  id: 0,
                  userId: 0,
                  label: '',
                  penerima: '',
                  alamat: '',
                  kecamatan: '',
                  kabupaten: '',
                  kodepos: '',
                  phone: '',
                  defaultAddress: false),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${setAddress.label} - ${setAddress.penerima}',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color(0xFF3D3D3D),
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${setAddress.alamat}, ${setAddress.kecamatan}, ${setAddress.kabupaten}, ${setAddress.kodepos}',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color(0xFF3D3D3D),
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          }),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAndOrderButton(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                    formatHarga.format(fetchDataCart.totalHarga.value),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: const Color(0xFF3D3D3D),
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F714F),
                minimumSize: Size(screenWidth * 0.35, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01, vertical: 12),
              ),
              child: Text(
                'Pesan',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onPressed: () async {
                if (fetchDataAddress.addresses.isEmpty) {
                  Get.snackbar(
                    'Peringatan',
                    'Silakan pilih alamat pengiriman',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                if (fetchDataCart.cart.isEmpty) {
                  Get.snackbar(
                    'Peringatan',
                    'Silakan pilih produk',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                if (waktuantarController.text.isEmpty) {
                  Get.snackbar(
                    'Peringatan',
                    'Tanggal antar harus diisi',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (jamController.text.isEmpty) {
                  Get.snackbar(
                    'Peringatan',
                    'Jam antar harus diisi',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                DateTime tglPesan = DateTime.now();
                DateTime tglAntar =
                    DateFormat('dd/MM/yyy').parse(waktuantarController.text);
                DateTime jamAntar;
                if (jamController.text.toLowerCase().contains('am') ||
                    jamController.text.toLowerCase().contains('pm')) {
                  jamAntar = DateFormat('hh:mm a').parse(jamController.text);
                }
                else {
                  jamAntar = DateFormat('HH:mm').parse(jamController.text);
                }

                final orderData = await fetchDataOrder.createOrder(
                  tglPesan: tglPesan,
                  tglAntar: tglAntar,
                  jam: jamAntar.toIso8601String(),
                  catatan: catatanController.text,
                );

                if (orderData['snap_token'] != null &&
                    orderData['order_id'] != null) {
                  final String snapToken = orderData['snap_token'];
                  final String orderId = orderData['order_id'].toString();
                  Get.toNamed(RouteName.pembayaran,
                      arguments: {'snapToken': snapToken, 'orderId': orderId});
                } else {
                  Get.snackbar('Error', 'Gagal mendapatkan token pembayaran',
                      snackPosition: SnackPosition.BOTTOM);
                }
              }),
        ],
      ),
    );
  }
}
