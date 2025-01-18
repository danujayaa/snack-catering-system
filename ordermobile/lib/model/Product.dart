class Product {
  static const baseUrl = 'http://yunna.bwa.biz.id';
  
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'Tidak Ada Deskripsi',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      // ignore: prefer_interpolation_to_compose_strings
      image: json['image'] != null && !json['image'].startsWith('http') 
          ? '$baseUrl${json['image']}' 
          : json['image'] ?? 'DEFAULT_IMAGE_URL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'image': image
    };
  }
}
