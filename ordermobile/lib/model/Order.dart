import 'package:ordermobile/model/Address.dart';
import 'package:ordermobile/model/Payment.dart';
import 'package:ordermobile/model/Product.dart';
import 'package:ordermobile/model/User.dart';

class Order {
  final int id;
  final int userId;
  final int addressId;
  final double totalPrice;
  final String status;
  final DateTime tglPesan;
  final DateTime tglAntar;
  final String jam;
  final String? catatan;
  final String? snapToken;
  final String? transactionStatus;
  final String? paymentMethod;
  final List<OrderItem> items;
  final Address address;
  final User user;
  final List<Payment> payments;

  Order({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.totalPrice,
    required this.status,
    required this.tglPesan,
    required this.tglAntar,
    required this.jam,
    this.catatan,
    this.snapToken,
    this.transactionStatus,
    this.paymentMethod,
    required this.items,
    required this.address,
    required this.user,
    required this.payments,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      addressId: int.tryParse(json['address_id'].toString()) ?? 0,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status'],
      tglPesan: DateTime.parse(json['tgl_pesan']),
      tglAntar: DateTime.parse(json['tgl_antar']),
      jam: json['jam'],
      catatan: json['catatan'] ?? 'Tidak Ada Catatan',
      snapToken: json['snap_token'],
      transactionStatus: json['transaction_status'],
      paymentMethod: json['payment_method'] ?? 'Belum dipilih',
      items: (json['order_items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      address: Address.fromJson(json['address']),
      user: User.fromJson(json['user']),
      payments: (json['payments'] as List<dynamic>?)
              ?.map((payment) => Payment.fromJson(payment))
              .toList() ??
          [],
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int jumlah;
  final double harga;
  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.jumlah,
    required this.harga,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: int.tryParse(json['order_id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      jumlah: int.tryParse(json['jumlah'].toString()) ?? 0,
      harga: double.tryParse(json['harga'].toString()) ?? 0.0,
      product: Product.fromJson(json['product']),
    );
  }
}

class TopProductOrder {
  final String productName;
  final String productImage;
  final int totalQuantity;

  TopProductOrder({
    required this.productName,
    required this.productImage,
    required this.totalQuantity,
  });

  factory TopProductOrder.fromJson(Map<String, dynamic> json) {
    return TopProductOrder(
      productName: json['product_name'],
      productImage: json['product_image'],
      totalQuantity: int.parse(json['total_quantity'].toString()),
    );
  }
}
