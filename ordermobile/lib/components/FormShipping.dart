import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FormShipping extends StatelessWidget {
  final TextEditingController waktuantarController;
  final TextEditingController jamController;
  final TextEditingController catatanController;

  const FormShipping({
    super.key,
    required this.waktuantarController,
    required this.jamController,
    required this.catatanController,
  });

  Future<void> _selectTanggal(BuildContext context) async {
    final DateTime minDate = DateTime.now().add(const Duration(days: 4));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minDate,
      firstDate: minDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      waktuantarController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _selectJam(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      jamController.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Column(
        children: [
          // Input Tanggal Antar
          TextFormField(
            controller: waktuantarController,
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Tanggal Antar',
              labelStyle:
                  GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15)),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () => _selectTanggal(context),
          ),
          const Divider(thickness: 1),

          // Input Jam Antar
          TextFormField(
            controller: jamController,
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Jam Antar',
              labelStyle:
                  GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15)),
              suffixIcon: const Icon(Icons.access_time),
            ),
            onTap: () => _selectJam(context),
          ),
          const Divider(thickness: 1),

          // Input Catatan
          TextFormField(
            controller: catatanController,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Catatan',
              labelStyle:
                  GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15)),
              hintText: 'Catatan Tambahan...',
              hintStyle:
                  GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15)),
            ),
            maxLines: 2,
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
