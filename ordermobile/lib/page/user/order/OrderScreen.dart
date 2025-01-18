import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/routes/route_name.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());
  String selectedStatus = 'unpaid';

  String formatHarga(double price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  Future<void> _refresh() async {
    await fetchDataOrder.fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pesanan Saya',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff3d3d3d),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Obx(() {
          if (fetchDataOrder.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xff7F714F),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat pesanan...',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff3d3d3d),
                      fontSize: width * 0.04,
                    ),
                  ),
                ],
              ),
            );
          }
          List<String> statusOrder = [
            'unpaid',
            'delivered',
            'pending',
            'confirmed',
            'completed',
            'canceled'
          ];

          final filteredOrders = fetchDataOrder.orders
              .where((order) => order.status.toLowerCase() == selectedStatus)
              .toList();

          filteredOrders.sort((a, b) {
            return statusOrder
                .indexOf(a.status.toLowerCase())
                .compareTo(statusOrder.indexOf(b.status.toLowerCase()));
          });

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Row(
                    children: [
                      _buildStatusChip(width, 'unpaid', 'Belum Dibayar'),
                      _buildStatusChip(width, 'pending', 'Menunggu'),
                      _buildStatusChip(width, 'confirmed', 'Dikonfirmasi'),
                      _buildStatusChip(width, 'delivered', 'Dikirim'),
                      _buildStatusChip(width, 'completed', 'Selesai'),
                      _buildStatusChip(width, 'canceled', 'Dibatalkan'),
                    ],
                  ),
                ),
              ),
              if (filteredOrders.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.food_bank,
                          size: width * 0.2,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada pesanan',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(width * 0.03),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final orderItem =
                          order.items.isNotEmpty ? order.items.first : null;
                      final product = orderItem?.product;

                      return GestureDetector(
                        onTap: () => Get.toNamed(RouteName.detailorder,
                            arguments: order),
                        child: Container(
                          margin: EdgeInsets.only(bottom: height * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product?.image ?? 'DEFAULT_IMAGE_URL',
                                        width: width * 0.2,
                                        height: width * 0.2,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: width * 0.2,
                                            height: width * 0.2,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8EEFF),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              color: const Color(0xff3d3d3d),
                                              size: width * 0.1,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: width * 0.05),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product?.name ?? 'Tidak ada produk',
                                            style: GoogleFonts.poppins(
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff2D3436),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            formatHarga(order.totalPrice),
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xff7F714F),
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildStatusBadge(
                                              width, order.status),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (order.status == 'unpaid') ...[
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Get.toNamed(RouteName.pembayaran,
                                                arguments: {
                                                  'snapToken': order.snapToken,
                                                  'orderId': order.id,
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff7F714F),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: height * 0.018,
                                            ),
                                          ),
                                          child: Text(
                                            'Bayar Sekarang',
                                            style: GoogleFonts.poppins(
                                              fontSize: width * 0.037,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.03),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await fetchDataOrder
                                              .cancelOrder(order.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                              color: Colors.red.shade400,
                                              width: 1,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.018,
                                              horizontal: width * 0.08),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Batalkan',
                                          style: GoogleFonts.poppins(
                                            fontSize: width * 0.037,
                                            color: Colors.red.shade400,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (order.status == 'delivered') ...[
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Silahkan klik Diterima jika pesanan sudah sampai',
                                          style: GoogleFonts.poppins(
                                            fontSize: width * 0.035,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await fetchDataOrder.updateOrder(
                                              order.id, 'completed');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff7F714F),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: height * 0.018,
                                            horizontal: width * 0.05,
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Diterima',
                                          style: GoogleFonts.poppins(
                                            fontSize: width * 0.037,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatusChip(double width, String status, String text) {
    final isSelected = selectedStatus == status;
    return Padding(
      padding: EdgeInsets.only(right: width * 0.02),
      child: ChoiceChip(
        selected: isSelected,
        label: Text(text),
        labelStyle: GoogleFonts.poppins(
          fontSize: width * 0.035,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xff3d3d3d),
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xff7F714F),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                isSelected ? const Color(0xff7F714F) : const Color(0xFFE0E0E0),
          ),
        ),
        onSelected: (bool selected) {
          setState(() => selectedStatus = status);
        },
        padding: EdgeInsets.symmetric(horizontal: width * 0.005, vertical: 8),
      ),
    );
  }

  Widget _buildStatusBadge(double width, String status) {
    final statusInfo = _getStatusInfo(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusInfo.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        statusInfo.text,
        style: GoogleFonts.poppins(
          color: statusInfo.color,
          fontSize: width * 0.03,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  StatusInfo _getStatusInfo(String status) {
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
        return StatusInfo('Selesai', const Color(0xFF4CAF50)); //hijau
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
