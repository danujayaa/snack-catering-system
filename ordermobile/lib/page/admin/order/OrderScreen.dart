import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/routes/route_name.dart';

class OrderAdminScreen extends StatelessWidget {
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());
  final TextEditingController searchController = TextEditingController();

  OrderAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      await fetchDataOrder.fetchOrder();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          'Daftar Pesanan',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: Obx(() {
              if (fetchDataOrder.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xff7F714F)),
                );
              } else if (fetchDataOrder.isError.value) {
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
                        'Error: ${fetchDataOrder.errorMessage.value}',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (fetchDataOrder.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.food_bank,
                        color: Color(0xff7F714F),
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pesanan',
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
                final filteredOrders = fetchDataOrder.orders
                    .where((order) => order.id.toString().contains(searchQuery))
                    .toList();
                const List<String> statusOrder = [
                  'unpaid',
                  'pending',
                  'confirmed',
                  'delivered',
                  'completed',
                  'canceled'
                ];

                filteredOrders.sort((a, b) {
                  int indexA = statusOrder.indexOf(a.status.toLowerCase());
                  int indexB = statusOrder.indexOf(b.status.toLowerCase());
                  return indexA.compareTo(indexB);
                });
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    final statusInfo = getStatusInfo(order.status);

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: Container(
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
                              Get.toNamed(RouteName.detailorderadmin,
                                  arguments: order);
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
                                        Icons.food_bank,
                                        color: Color(0xff7F714F),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID Pesanan ${order.id}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff3d3d3d),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusInfo.color,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            statusInfo.text,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xff7F714F),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          )
        ],
      ),
    );
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
          fetchDataOrder.fetchSearchOrder(value);

          if (value.isNotEmpty && fetchDataOrder.orders.isEmpty) {
            searchController.clear();
            fetchDataOrder.fetchOrder();
          }
        },
        onChanged: (value) {
          fetchDataOrder.fetchSearchOrder(value);

          if (value.isNotEmpty && fetchDataOrder.orders.isEmpty) {
            searchController.clear();
            fetchDataOrder.fetchOrder();
          }
        },
      ),
    );
  }

  StatusInfo getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'unpaid':
        return StatusInfo('Belum Dibayar', const Color(0xFFE53935)); //merah
      case 'pending':
        return StatusInfo('Menunggu', const Color(0xFFFF6B00)); //orange
      case 'confirmed':
        return StatusInfo('Dikonfirmasi', const Color(0xFF2196F3)); //biru
      case 'delivered':
        return StatusInfo('Dikirim', const Color(0xFF4CAF50)); //hijau
      case 'completed':
        return StatusInfo('Diterima', const Color(0xFF4CAF50)); //hijau
      case 'canceled':
        return StatusInfo('Dibatalkan', const Color(0xFFE53935)); //merah
      default:
        return StatusInfo('Tidak diketahui', const Color(0xFF64748B)); //abu-abu
    }
  }
}

class StatusInfo {
  final String text;
  final Color color;

  StatusInfo(this.text, this.color);
}
