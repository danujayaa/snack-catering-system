import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordermobile/controller/FetchDataCategory.dart';
import 'package:ordermobile/controller/FetchDataProduct.dart';
import 'package:ordermobile/model/Product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  int? _selectedCategoryId;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.find<FetchDataCategory>().fetchCategory();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileSize = await File(pickedFile.path).length();
      if (fileSize > 2 * 1024 * 1024) {
        Get.snackbar('Error', 'Ukuran gambar maksimal 2MB',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      setState(() {
        _image = pickedFile;
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
          'Tambah Produk Baru',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: Color(0xff3d3d3d),
                fontSize: 20,
                fontWeight: FontWeight.w600),
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
                        labelText: 'Deskripsi Produk',
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
                        labelText: 'Harga Produk',
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
                    Obx(() {
                      final categoryController = Get.find<FetchDataCategory>();
                      if (categoryController.isError.value) {
                        return Center(
                          child: Text(
                            'Error: ${categoryController.errorMessage.value}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xffDCDCDC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xffBDBDBD)),
                          ),
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            value: _selectedCategoryId,
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
                                .map<DropdownMenuItem<int>>((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Color(0xff3d3d3d)))),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Kategori harus dipilih';
                              }
                              return null;
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xff3d3d3d),
                              size: 28,
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffBDBDBD)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _image == null
                            ? Center(
                                child: Text(
                                  'Klik untuk upload gambar (Max 2MB)',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : Image.file(
                                File(_image!.path),
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
                if (formKey.currentState!.validate()) {
                  if (_image == null) {
                    Get.snackbar('Error', 'Gambar harus diupload',
                        snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  final newProduct = Product(
                    id: 0,
                    name: nameController.text,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    categoryId: _selectedCategoryId!,
                    image: _image!.path,
                  );

                  Get.find<FetchDataProduct>().addProduct(newProduct);

                  Get.back();
                }
              },
              child: Text(
                'Tambah Produk',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7F714F),
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
