import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordermobile/controller/FetchDataCategory.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/model/Product.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final categoryController = Get.find<FetchDataCategory>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  XFile? newImage;
  int? selectedCategoryId;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    selectedCategoryId = widget.product.categoryId;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final fileSize = await File(pickedImage.path).length();
      if (fileSize > 2 * 1024 * 1024) {
        Get.snackbar('Error', 'Ukuran gambar maksimal 2MB',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      setState(() {
        newImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        
        elevation: 0,
        title: Text(
          'Edit Produk',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                        labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(color: Color(0xff3d3d3d)),
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama produk harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(color: Color(0xff3d3d3d)),
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Harga',
                        labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(color: Color(0xff3d3d3d)),
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga produk harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xffDCDCDC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xffBDBDBD)),
                      ),
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value: selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: 'Pilih Kategori',
                          labelStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Color(0xff3d3d3d),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xff3d3d3d),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: categoryController.categories
                            .map((category) => DropdownMenuItem<int>(
                                  value: category.id,
                                  child: Text(category.name,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              color: Color(0xff3d3d3d)))),
                                ))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            selectedCategoryId = value;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff3d3d3d),
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffBDBDBD)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: newImage == null
                            ? (widget.product.image.isEmpty
                                ? Text(
                                    'Tidak Ada Gambar',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          color: Color(0xff3d3d3d)),
                                    ),
                                  )
                                : Image.network(
                                    widget.product.image,
                                    fit: BoxFit.cover,
                                  ))
                            : Image.file(
                                File(newImage!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final updatedProduct = Product(
                    id: widget.product.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    categoryId: selectedCategoryId ??
                        categoryController.categories.first.id,
                    image: widget.product.image,
                  );

                  Get.find<FetchDataProduct>().updateProduct(
                    widget.product.id,
                    updatedProduct,
                    newImage: newImage,
                  );
                  Get.back();
                }
              },
              child: Text(
                'Update',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7F714F),
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
