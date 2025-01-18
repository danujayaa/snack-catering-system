import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final order;
  final String Function(double) formatHarga;
  final VoidCallback bayar;
  final VoidCallback batal;
  final VoidCallback selesai;

  const OrderCard({
    super.key,
    required this.order,
    required this.formatHarga,
    required this.bayar,
    required this.batal,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    final product = order.items.isNotEmpty ? order.items.first.product : null;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product?.image ?? 'DEFAULT_IMAGE_URL',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFE8EEFF),
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xff3d3d3d),
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? 'Tidak ada produk',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusBadge(order.status),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (order.status == 'unpaid') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: batal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Batalkan',
                        style: GoogleFonts.poppins(
                          color: const Color(0xff3d3d3d),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: bayar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7F714F),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Bayar Sekarang',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (order.status == 'delivered') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: selesai,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7F714F),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Konfirmasi Diterima',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
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
  }

  Widget _buildStatusBadge(String status) {
    String text = '';
    Color color = Colors.grey;

    switch (status.toLowerCase()) {
      case 'unpaid':
        text = 'Belum Dibayar';
        color = Colors.red;
        break;
      case 'delivered':
        text = 'Dikirim';
        color = Colors.blue;
        break;
      case 'completed':
        text = 'Selesai';
        color = Colors.green;
        break;
      case 'canceled':
        text = 'Dibatalkan';
        color = Colors.grey;
        break;
      default:
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
