class Cart {
  final int id;
  final int productId;
  final String productName;
  final double productPrice;
  final int jumlah;
  final String productImage;

  Cart({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.jumlah,
    required this.productImage,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product']
          ['name'],
      productPrice: double.tryParse(json['product']['price'].toString()) ?? 0.0,
      jumlah: json['jumlah'],
      productImage: json['product']['image'],
    );
  }
}
