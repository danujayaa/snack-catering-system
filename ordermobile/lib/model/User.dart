import 'package:ordermobile/model/Address.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String password;
  String role;
  List<Address> addresses;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.addresses = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var addressesFromJson = json['addresses'] as List?;
    List<Address> addressList = addressesFromJson != null
        ? addressesFromJson.map((i) => Address.fromJson(i)).toList()
        : [];
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'] ?? '',
      role: json['role'],
      addresses: addressList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, role: $role}';
  }
}
