import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/model/Order.dart';

class DetailOrderScreen extends StatelessWidget {
  final Order order;

  const DetailOrderScreen({super.key, required this.order});

  String formatRupiah(double harga) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(harga);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          'Detail Pesanan',
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
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderInfoSection(screenWidth),
              const SizedBox(height: 20),
              _buildProductList(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoSection(double screenWidth) {
    final statusInfo = getStatusInfo(order.status);
    return Card(
      elevation: 6,
      color: const Color(0xfffefefe),
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.orange[400], size: 28),
                const SizedBox(width: 8),
                Text(
                  'Informasi Pesanan',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            _buildInfoRow(screenWidth, 'ID Pesanan', order.id.toString()),
            _buildInfoRow(
                screenWidth, 'Status', statusInfo.text, statusInfo.color),
            _buildInfoRow(screenWidth, 'Total', formatRupiah(order.totalPrice)),
            _buildInfoRow(screenWidth, 'Tanggal Pesan',
                DateFormat('dd MMMM yyyy').format(order.tglPesan)),
            _buildInfoRow(screenWidth, 'Tanggal Antar',
                DateFormat('dd MMMM yyyy').format(order.tglAntar)),
            _buildInfoRow(screenWidth, 'Jam', order.jam),
            _buildInfoRow(
                screenWidth, 'Catatan', order.catatan ?? 'Tidak Ada Catatan'),
            _buildInfoRow(screenWidth, 'Tempat', order.address.label),
            _buildInfoRow(screenWidth, 'Alamat',
                '${order.address.alamat}, ${order.address.kecamatan}, ${order.address.kabupaten}, ${order.address.kodepos}, ${order.address.phone}'),
            _buildInfoRow(screenWidth, 'Metode Pembayaran',
                order.paymentMethod ?? 'Tidak Ada Metode Pembayaran'),
            _buildInfoRow(
                screenWidth,
                'Status Transaksi',
                paymentStatus(
                    order.transactionStatus ?? 'Tidak Ada Status Transaksi'))
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(double screenWidth, String label, String value,
      [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: valueColor ?? Colors.grey[700],
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(double screenWidth) {
    return Card(
      elevation: 6,
      color: const Color(0xfffefefe),
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.food_bank, color: Colors.brown[300], size: 28),
                const SizedBox(width: 8),
                Text(
                  'Daftar Produk',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final orderItem = order.items[index];
                final product = orderItem.product;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: const Color(0xfff7f6f5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        product.image,
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EEFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: const Color(0xff3d3d3d),
                              size: screenWidth * 0.1,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.brown[800],
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    subtitle: Text(
                      'Jumlah: ${orderItem.jumlah} x ${formatRupiah(orderItem.harga)}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                    trailing: Text(
                      formatRupiah(orderItem.jumlah * orderItem.harga),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                          color: Colors.brown[700]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
        return StatusInfo('Belum Dibayar', const Color(0xFFE53935)); // Merah
      case 'pending':
        return StatusInfo('Menunggu', const Color(0xFFFF6B00)); // Orange
      case 'confirmed':
        return StatusInfo('Dikonfirmasi', const Color(0xFF2196F3)); // Biru
      case 'delivered':
        return StatusInfo('Dikirim', const Color(0xFF4CAF50)); // Hijau
      case 'completed':
        return StatusInfo('Selesai', const Color(0xFF4CAF50)); // Hijau
      case 'canceled':
        return StatusInfo('Dibatalkan', const Color(0xFFE53935)); // Merah
      default:
        return StatusInfo(
            'Tidak diketahui', const Color(0xFF64748B)); // Abu-abu
    }
  }
}

class StatusInfo {
  final String text;
  final Color color;

  StatusInfo(this.text, this.color);
}
