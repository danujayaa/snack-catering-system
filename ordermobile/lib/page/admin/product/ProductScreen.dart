import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ordermobile/controller/FetchDataCategory.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/model/Category.dart';
import 'package:ordermobile/model/Product.dart';
import 'package:ordermobile/routes/route_name.dart';

class ProductAdminScreen extends StatelessWidget {
  final FetchDataProduct fetchDataProduct = Get.put(FetchDataProduct());
  final FetchDataCategory fetchDataCategory = Get.put(FetchDataCategory());
  final TextEditingController searchController = TextEditingController();
  final Rx<String?> selectedCategory = Rx<String?>(null);

  ProductAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        
        elevation: 0,
        title: Text(
          "Produk",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Color(0xff3d3d3d),
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 35,
              height: 35,
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed(RouteName.addproductadmin);
                },
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: EdgeInsets.zero),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          _buildFilterCategory(),
          Expanded(
            child: Obx(() {
              if (fetchDataProduct.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (fetchDataProduct.isError.value) {
                return Center(
                    child:
                        Text('Error: ${fetchDataProduct.errorMessage.value}'));
              } else if (fetchDataProduct.products.isEmpty) {
                return const Center(child: Text('Tidak Ada Data Produk.'));
              } else {
                final filterProduct =
                    fetchDataProduct.products.where((product) {
                  return selectedCategory.value == null ||
                      product.categoryId.toString() == selectedCategory.value;
                }).toList();
                return ProductList(filterProduct, screenWidth: screenWidth);
              }
            }),
          )
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Cari Nama Produk',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff7F714F),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          fetchDataProduct.fetchSearchProduct(value);
        },
      ),
    );
  }

  Widget _buildFilterCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Obx(
        () {
          if (fetchDataCategory.isError.value) {
            return Center(
                child: Text('Error: ${fetchDataCategory.errorMessage.value}'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                    spacing: 5.0,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          selectedCategory.value = null;
                          fetchDataProduct.fetchProduct();
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: selectedCategory.value == null
                                ? const Color(0xff7F714F)
                                : Colors.transparent,
                            foregroundColor: selectedCategory.value == null
                                ? Colors.white
                                : const Color(0xff3d3d3d)),
                        child: Text(
                          "Semua",
                          style: GoogleFonts.poppins(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ),
                      ...fetchDataCategory.categories.map((Category category) {
                        return OutlinedButton(
                          onPressed: () {
                            selectedCategory.value = category.id.toString();
                            fetchDataProduct.fetchProduct();
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: selectedCategory.value ==
                                      category.id.toString()
                                  ? const Color(0xff7F714F)
                                  : Colors.transparent,
                              foregroundColor: selectedCategory.value ==
                                      category.id.toString()
                                  ? Colors.white
                                  : const Color(0xff3d3d3d)),
                          child: Text(
                            category.name,
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  final double screenWidth;

  const ProductList(this.products, {super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: products.length,
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
      ),
      itemBuilder: (context, index) {
        return ProductItem(product: products[index], screenWidth: screenWidth);
      },
    );
  }
}

class ProductItem extends StatefulWidget {
  final Product product;
  final double screenWidth;

  const ProductItem(
      {super.key, required this.product, required this.screenWidth});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    name: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final categoryName = Get.find<FetchDataCategory>()
        .categories
        .firstWhere((category) => category.id == widget.product.categoryId,
            orElse: () => Category(id: 0, name: 'Tidak Ditemukan'))
        .name;

    double fontSizeTitle = widget.screenWidth * 0.04;
    double fontSizePriceCategory = widget.screenWidth * 0.035;
    double fontSizeButton = widget.screenWidth * 0.04;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.product.image.isEmpty
                ? Container(
                    height: widget.screenWidth * 0.15,
                    width: widget.screenWidth * 0.15,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  )
                : Image.network(
                    widget.product.image,
                    height: widget.screenWidth * 0.15,
                    width: widget.screenWidth * 0.15,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.product.name,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: const Color(0xff3d3d3d),
                      fontWeight: FontWeight.w700,
                      fontSize: fontSizeTitle,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _currencyFormat.format(widget.product.price),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: fontSizePriceCategory,
                          color: const Color(0xff7F714F),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      categoryName,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: fontSizePriceCategory,
                          color: const Color(0xff7F714F),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Get.toNamed(RouteName.editproductadmin,
                      arguments: widget.product);
                },
                child: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: fontSizeButton,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Get.find<FetchDataProduct>()
                        .deleteProduct(widget.product.id);
                  },
                  child: Text(
                    'Hapus',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSizeButton,
                        color: Colors.red,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
