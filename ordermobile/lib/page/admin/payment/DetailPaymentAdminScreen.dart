import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/controller/FetchDataPayment.dart';
import 'package:ordermobile/model/Payment.dart';

class DetailPaymentScreen extends StatelessWidget {
  final Payment payment;
  final FetchDataPayment fetchDataPayment = Get.put(FetchDataPayment());

  DetailPaymentScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Pembayaran',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
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
        }
        return _buildMainContent();
      }),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 20),
          _buildDetailsCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (payment.paymentStatus.toLowerCase()) {
      case 'settlement':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Berhasil';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        statusText = 'Menunggu';
        break;
      case 'failure':
        statusColor = Colors.red;
        statusIcon = Icons.error_outline;
        statusText = 'Gagal';
        break;
      case 'cancel':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Dibatalkan';
        break;
      case 'deny':
        statusColor = Colors.grey;
        statusIcon = Icons.error_outline;
        statusText = 'Ditolak';
        break;
      case 'expire':
        statusColor = Colors.grey;
        statusIcon = Icons.timer_off_rounded;
        statusText = 'Kadaluwarsa';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.error_outline;
        statusText = 'Tidak Diketahui';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(payment.amount),
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xff3d3d3d),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: GoogleFonts.poppins(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Informasi Pembayaran',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xff3d3d3d),
              ),
            ),
          ),
          const Divider(height: 1),
          _buildDetailItem(
            'ID Pesanan',
            payment.orderId.toString(),
            Icons.receipt_long,
            const Color(0xFF6B7280),
          ),
          _buildDetailItem(
            'ID Transaksi',
            payment.transactionId,
            Icons.confirmation_number,
            const Color(0xFF7F714F),
          ),
          _buildDetailItem(
            'Metode Pembayaran',
            payment.paymentMethod,
            Icons.payment,
            const Color(0xFF4F46E5),
          ),
          _buildDetailItem(
            'Tanggal Transaksi',
            DateFormat('dd MMM yyyy, HH:mm').format(payment.transactionDate),
            Icons.event,
            const Color(0xFF0891B2),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color iconColor, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
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
                        fontSize: 16,
                        color: const Color(0xff3d3d3d),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 56,
          ),
      ],
    );
  }
}
