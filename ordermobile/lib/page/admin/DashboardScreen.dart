import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/components/TopOrder.dart';
import 'package:ordermobile/controller/FetchDataAddress.dart';
import 'package:ordermobile/controller/FetchDataCategory.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/controller/FetchDataPayment.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/controller/FetchDataUser.dart';
import 'package:ordermobile/routes/route_name.dart';

class DashboardScreen extends StatelessWidget {
  final FetchDataPayment fetchDataPayment = Get.put(FetchDataPayment());
  final FetchDataCategory fetchDataCategory = Get.put(FetchDataCategory());
  final FetchDataProduct fetchDataProduct = Get.put(FetchDataProduct());
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());
  final FetchDataUser fetchDataUser = Get.put(FetchDataUser());
  final FetchDataAddress fetchDataAddress = Get.put(FetchDataAddress());

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double paddingHorizontal = width * 0.035;
    double paddingVertical = height * 0.01;
    double paddingContainerHorizontal = width * 0.05;
    double paddingContainerVertical = height * 0.025;
    double fontSizeTitle = width * 0.042;
    double fontSizeValue = width * 0.043;

    final formatHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Dashboard',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Color(0xff3d3d3d),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (fetchDataProduct.isLoading.value ||
            fetchDataCategory.isLoading.value ||
            fetchDataUser.isLoading.value ||
            fetchDataOrder.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (fetchDataProduct.isError.value ||
            fetchDataCategory.isError.value ||
            fetchDataUser.isError.value ||
            fetchDataOrder.isError.value) {
          String errorMessage = '';
          if (fetchDataProduct.isError.value) {
            errorMessage =
                'Error Produk: ${fetchDataProduct.errorMessage.value}';
          } else if (fetchDataCategory.isError.value) {
            errorMessage =
                'Error Kategori: ${fetchDataCategory.errorMessage.value}';
          } else if (fetchDataUser.isError.value) {
            errorMessage =
                'Error Pengguna: ${fetchDataUser.errorMessage.value}';
          } else if (fetchDataOrder.isError.value) {
            errorMessage =
                'Error Pesanan: ${fetchDataOrder.errorMessage.value}';
          }
          return Center(
            child: Text(errorMessage),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: paddingVertical),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: buildStatCard(
                          'Total Pendapatan',
                          formatHarga
                              .format(fetchDataPayment.totalPendapatan.value),
                          Icons.money_rounded,
                          fontSizeTitle,
                          fontSizeValue,
                          paddingContainerHorizontal,
                          paddingContainerVertical),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.productadmin);
                        },
                        child: buildStatCard(
                          'Produk',
                          fetchDataProduct.getTotalProducts().toString(),
                          Icons.food_bank,
                          fontSizeTitle,
                          fontSizeValue,
                          paddingContainerHorizontal,
                          paddingContainerVertical,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.useradmin);
                        },
                        child: buildStatCard(
                          'Pengguna',
                          fetchDataUser.getTotalUsers().toString(),
                          Icons.person,
                          fontSizeTitle,
                          fontSizeValue,
                          paddingContainerHorizontal,
                          paddingContainerVertical,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.orderadmin);
                        },
                        child: buildStatCard(
                          'Pesanan',
                          fetchDataOrder.getTotalOrders().toString(),
                          Icons.shopping_basket_rounded,
                          fontSizeTitle,
                          fontSizeValue,
                          paddingContainerHorizontal,
                          paddingContainerVertical,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TopProductOrdersCustomScreen(),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget buildStatCard(
    String title,
    String value,
    IconData icon,
    double fontSizeTitle,
    double fontSizeValue,
    double paddingContainerHorizontal,
    double paddingContainerVertical,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: paddingContainerHorizontal,
          vertical: paddingContainerVertical),
      decoration: BoxDecoration(
        color: const Color(0xFF7F714F),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: fontSizeTitle,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: fontSizeValue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
