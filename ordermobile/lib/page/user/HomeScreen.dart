import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/components/CarouselWidget.dart';
import 'package:ordermobile/components/ProductWidget.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/controller/FetchDataCategory.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/routes/route_name.dart';

class HomeScreen extends StatelessWidget {
  final FetchDataProduct fetchDataProduct = Get.put(FetchDataProduct());
  final FetchDataCategory fetchDataCategory = Get.put(FetchDataCategory());
  final TextEditingController searchController = TextEditingController();
  final Rx<String?> selectedCategory = Rx<String?>(null);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    Future<void> refresh() async {
      await fetchDataProduct.fetchProduct();
      await fetchDataCategory.fetchCategory();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: screenHeight * 0.1,
                floating: false,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildAppBar(authController, screenWidth),
                ),
                automaticallyImplyLeading: false,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildSearchField(screenWidth, screenHeight),
                    CarouselWidget(),
                    _buildCategoryHeader(screenWidth),
                    _buildFilterCategory(screenWidth),
                  ],
                ),
              ),
              _buildProductGridSliver(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AuthController authController, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      color: const Color(0xFFF8F9FD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final userName = authController.isLoggedIn.value
                      ? authController.user.value.name
                      : 'Pengguna Tidak Terdaftar';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang,",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3d3d3d),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icon/cart.svg",
              width: screenWidth * 0.1,
              height: screenWidth * 0.1,
            ),
            onPressed: () => Get.toNamed(RouteName.keranjang),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Cari Produk...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        ),
        onChanged: (value) => fetchDataProduct.fetchSearchProduct(value),
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500, color: const Color(0xff3d3d3d)),
      ),
    );
  }

  Widget _buildCategoryHeader(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenWidth * 0.01),
      child: Row(
        children: [
          Text(
            'Kategori',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xff3d3d3d),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Obx(() {
        if (fetchDataCategory.isError.value) {
          return Center(
            child: Text('Error: ${fetchDataCategory.errorMessage.value}'),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton(
                  label: "Semua",
                  isSelected: selectedCategory.value == null,
                  onPressed: () {
                    selectedCategory.value = null;
                    fetchDataProduct.fetchProduct();
                  },
                ),
                ...fetchDataCategory.categories.map((category) {
                  return _buildCategoryButton(
                    label: category.name,
                    isSelected:
                        selectedCategory.value == category.id.toString(),
                    onPressed: () {
                      selectedCategory.value = category.id.toString();
                      fetchDataProduct.fetchProduct();
                    },
                  );
                }),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xff7F714F) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xff3d3d3d),
          elevation: isSelected ? 5 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey[300]!,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridSliver(double screenWidth) {
    return Obx(() {
      if (fetchDataProduct.isLoading.value) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Color(0xff7F714F)),
                const SizedBox(height: 16),
                Text(
                  'Memuat produk...',
                  style: GoogleFonts.poppins(
                    color: const Color(0xff3d3d3d),
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (fetchDataProduct.isError.value) {
        return SliverFillRemaining(
          child: Center(
            child: Text(
              'Error: ${fetchDataProduct.errorMessage.value}',
              style: GoogleFonts.poppins(
                color: const Color(0xff3d3d3d),
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        );
      } else {
        final filteredProducts = fetchDataProduct.products.where((product) {
          final matchesCategory = selectedCategory.value == null ||
              product.categoryId.toString() == selectedCategory.value;
          final matchesSearch = product.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        if (filteredProducts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/product_empty.svg',
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada produk',
                      style: GoogleFonts.poppins(
                        color: const Color(0xff3d3d3d),
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              childAspectRatio: screenWidth > 600 ? 0.7 : 0.8,
              crossAxisSpacing: screenWidth * 0.03,
              mainAxisSpacing: screenWidth * 0.03,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.detailproduct, arguments: product);
                  },
                  child: ProductWidget(
                    title: product.name,
                    price: product.price,
                    image: product.image,
                  ),
                );
              },
              childCount: filteredProducts.length,
            ),
          ),
        );
      }
    });
  }
}
