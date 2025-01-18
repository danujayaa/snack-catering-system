import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataPayment.dart';
import 'package:ordermobile/routes/route_name.dart';

class PaymentScreenAdmin extends StatelessWidget {
  final FetchDataPayment fetchDataPayment = Get.put(FetchDataPayment());
  final TextEditingController searchController = TextEditingController();

  PaymentScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Pembayaran',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Color(0xff3d3d3d),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Column(children: [
          _buildSearchField(),
          Expanded(
            child: Obx(() {
              if (fetchDataPayment.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xff7F714F)),
                );
              } else if (fetchDataPayment.isError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${fetchDataPayment.errorMessage.value}',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (fetchDataPayment.payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.payment_rounded,
                        color: Color(0xff7F714F),
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pembayaran',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: const Color(0xff7F714F),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                final searchQuery = searchController.text;
                final filteredPayments =
                    fetchDataPayment.payments.where((payment) {
                  return payment.orderId.toString().contains(searchQuery);
                }).toList();

                if (filteredPayments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          color: Colors.grey,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ditemukan hasil untuk "$searchQuery"',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredPayments.length,
                    itemBuilder: (context, index) {
                      final payment = filteredPayments[index];
                      final statusPayment =
                          getStatusPayment(payment.paymentStatus);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Get.toNamed(RouteName.detailpembayaranadmin,
                                  arguments: payment);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7F714F)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.receipt_long,
                                        color: Color(0xff7F714F),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID Pesanan ${payment.orderId}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff3d3d3d),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusPayment.color,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            statusPayment.text,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xff7F714F),
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
          )
        ]));
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          hintText: 'Cari ID Pesanan',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff7F714F),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSubmitted: (value) {
          fetchDataPayment.fetchSearchPayment(value);

          if (value.isNotEmpty && fetchDataPayment.payments.isEmpty) {
            searchController.clear();
            fetchDataPayment.fetchPayment();
          }
        },
        onChanged: (value) {
          fetchDataPayment.fetchSearchPayment(value);

          if (value.isNotEmpty && fetchDataPayment.payments.isEmpty) {
            searchController.clear();
            fetchDataPayment.fetchPayment();
          }
        },
      ),
    );
  }

  StatusPayment getStatusPayment(String status) {
    switch (status.toLowerCase()) {
      case 'settlement':
        return StatusPayment('Berhasil', Colors.green);
      case 'pending':
        return StatusPayment('Menunggu Pembayaran', Colors.orange);
      case 'failure':
        return StatusPayment('Gagal', Colors.red);
      case 'cancel':
        return StatusPayment('Dibatalkan', Colors.red);
      case 'deny':
        return StatusPayment('Ditolak', Colors.grey);
      case 'expire':
        return StatusPayment('Kadaluwarsa', Colors.grey);
      default:
        return StatusPayment('Tidak Diketahui', Colors.grey);
    }
  }
}

class StatusPayment {
  final String text;
  final Color color;

  StatusPayment(this.text, this.color);
}
