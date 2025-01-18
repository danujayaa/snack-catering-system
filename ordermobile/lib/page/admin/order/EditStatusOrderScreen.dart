import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/model/Order.dart';

class EditOrderStatusScreen extends StatefulWidget {
  final Order order;

  const EditOrderStatusScreen({super.key, required this.order});

  @override
  _EditOrderStatusScreenState createState() => _EditOrderStatusScreenState();
}

class _EditOrderStatusScreenState extends State<EditOrderStatusScreen> {
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  (Color, String) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (Colors.orange, 'Menunggu'); //biru
      case 'confirmed':
        return (const Color(0xFF2196F3), 'Dikonfirmasi'); //biru
      case 'delivered':
        return (const Color(0xFF4CAF50), 'Dikirim'); //hijau
      default:
        return (const Color(0xFF64748B), status); //abu-abu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Edit Status Pesanan',
          style: GoogleFonts.poppins(
            color: const Color(0xff3d3d3d),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status Saat Ini',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff3d3d3d),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _getStatusInfo(widget.order.status).$1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusInfo(widget.order.status).$1,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusInfo(widget.order.status).$2,
                    style: GoogleFonts.poppins(
                      color: _getStatusInfo(widget.order.status).$1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Status Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff3d3d3d),
                  ),
                ),
                const SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatusOption('confirmed'),
                    _buildStatusOption('delivered'),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7F714F),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                try {
                  await _updateStatus();
                  Get.snackbar('Sukses', 'Status pesanan berhasil diperbarui',
                      backgroundColor: Colors.green, colorText: Colors.white);
                } catch (e) {
                  Get.snackbar('Gagal', 'Gagal memperbarui status pesanan',
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Text(
                'Simpan Perubahan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(String status) {
    final (color, text) = _getStatusInfo(status);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selectedStatus == status
              ? const Color(0xff7F714F)
              : Colors.grey.withOpacity(0.2),
          width: selectedStatus == status ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        value: status,
        groupValue: selectedStatus,
        activeColor: const Color(0xff7F714F),
        onChanged: (value) {
          setState(() {
            selectedStatus = value;
          });
        },
      ),
    );
  }

  Future<void> _updateStatus() async {
    if (selectedStatus != null) {
      Get.find<FetchDataOrder>().updateOrder(
        widget.order.id,
        selectedStatus!,
      );

      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih status')),
      );
    }
  }
}
