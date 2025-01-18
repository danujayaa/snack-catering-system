import 'package:ordermobile/model/User.dart';

class Address {
  final int id;
  final int userId;
  final String label;
  final String penerima;
  final String alamat;
  final String kecamatan;
  final String kabupaten;
  final String kodepos;
  final String phone;
  final bool defaultAddress;
  User? user;

  Address({
    required this.id,
    required this.userId,
    required this.label,
    required this.penerima,
    required this.alamat,
    required this.kecamatan,
    required this.kabupaten,
    required this.kodepos,
    required this.phone,
    required this.defaultAddress,
    this.user,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      label: json['label'],
      penerima: json['penerima'],
      alamat: json['alamat_lengkap'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      kodepos: json['kode_pos'],
      phone: json['phone'],
      defaultAddress: json['default'] == 1,
      user: json.containsKey('user') ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'penerima': penerima,
      'alamat_lengkap': alamat,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'kode_pos': kodepos,
      'phone': phone,
      'default': defaultAddress,
      if (user != null) 'user': user!.toJson(),
    };
  }
}
