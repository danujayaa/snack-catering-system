import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/model/Order.dart';
import 'package:ordermobile/routes/route_name.dart';

class DetailAdminOrderScreen extends StatelessWidget {
  final Order order;
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());

  DetailAdminOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          'Detail ID Pesanan ${order.id}',
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
      body: Obx(
        () {
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
                    Icons.shopping_basket_outlined,
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
          }
          final Order updatedOrder =
              fetchDataOrder.orders.firstWhere((o) => o.id == order.id);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
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
                  child: _buildStatusRow(updatedOrder.status),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  child: Column(
                    children: [
                      _buildSection(
                        'Informasi Pelanggan',
                        [
                          _buildDetailRow(
                              Icons.person, 'Pengguna', order.user.name),
                          _buildDetailRow(Icons.person_2, 'Penerima',
                              order.address.penerima),
                          _buildDetailRow(
                              Icons.home, 'Label Tempat', order.address.label),
                          _buildDetailRow(Icons.location_on, 'Alamat',
                              '${order.address.alamat}, ${order.address.kecamatan}, ${order.address.kabupaten}, ${order.address.kodepos}, ${order.address.phone}'),
                        ],
                      ),
                      const Divider(height: 1),
                      _buildSection(
                        'Informasi Pesanan',
                        [
                          _buildDetailRow(
                            Icons.calendar_today,
                            'Tanggal Pesan',
                            DateFormat('dd MMM yyyy').format(order.tglPesan),
                          ),
                          _buildDetailRow(
                            Icons.access_time,
                            'Waktu Pengiriman',
                            '${DateFormat('dd MMM yyyy').format(order.tglAntar)} ${DateFormat('HH:mm').format(DateTime.parse('${order.tglAntar.toString().split(' ')[0]} ${order.jam}'))}',
                          ),
                          _buildDetailRow(
                            Icons.shopping_cart,
                            'Produk',
                            order.items.map((p) => p.product.name).join(', '),
                          ),
                          _buildDetailRow(
                              Icons.note, 'Catatan', order.catatan!),
                        ],
                      ),
                      const Divider(height: 1),
                      _buildSection(
                        'Informasi Pembayaran',
                        [
                          _buildDetailRow(
                            Icons.attach_money,
                            'Total Harga',
                            NumberFormat.currency(
                                    locale: 'id_ID', symbol: 'Rp ')
                                .format(order.totalPrice),
                            isPrice: true,
                          ),
                          _buildDetailRow(
                            Icons.shopping_basket,
                            'Jumlah Item',
                            order.items.map((jml) => jml.jumlah).join(', '),
                          ),
                          _buildDetailRow(
                            Icons.payment,
                            'Status Pembayaran',
                            order.payments
                                .map((pay) => paymentStatus(pay.paymentStatus))
                                .join(', '),
                          ),
                          _buildDetailRow(
                            Icons.credit_card,
                            'Metode Pembayaran',
                            order.payments
                                .map((pay) => pay.paymentMethod)
                                .join(', '),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (updatedOrder.status.toLowerCase() != 'unpaid' &&
                    updatedOrder.status.toLowerCase() != 'completed' &&
                    updatedOrder.status.toLowerCase() != 'canceled')
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(RouteName.editstatusorderadmin,
                          arguments: order);
                    },
                    child: Text(
                      'Edit Status',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7F714F),
                      minimumSize: const Size(350, 40),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    final statusInfo = getStatusInfo(status);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status Pesanan',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xff3d3d3d),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusInfo.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusInfo.text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xff3d3d3d),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff7F714F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xff7F714F),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: isPrice ? 16 : 14,
                    fontWeight: isPrice ? FontWeight.w600 : FontWeight.w500,
                    color: isPrice
                        ? const Color(0xff7F714F)
                        : const Color(0xff3d3d3d),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String paymentStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Belum Dibayar';
      case 'settlement':
        return 'Dibayar';
      case 'cancel':
        return 'Dibatalkan';
      case 'deny':
        return 'Ditolak';
      case 'expire':
        return 'Kedaluwarsa';
      case 'failure':
        return 'Gagal';
      default:
        return status;
    }
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
