import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordermobile/model/Product.dart';
import 'package:http/http.dart' as http;
import 'package:ordermobile/service/AuthService.dart';

class FetchDataProduct extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.soexma.com';
  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
    final token = await authService.getToken();
    isLoading(true);
    isError(false);

    try {
      final responseProducts = await http.get(
        Uri.parse('$baseUrl/api/products'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (responseProducts.statusCode == 200) {
        List<dynamic> jsonProducts = json.decode(responseProducts.body);
        products.value = jsonProducts.map((data) {
          if (data['image'] != null && !data['image'].startsWith('http')) {
            data['image'] = '$baseUrl${data['image']}';
          }
          return Product.fromJson(data);
        }).toList();
      } else {
        isError(true);
        errorMessage('Gagal Memuat Produk');
        products.value = [];
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
      products.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSearchProduct(String query) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final responseProducts = await http.get(
        Uri.parse('$baseUrl/api/search?query=$query'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (responseProducts.statusCode == 200) {
        List<dynamic> jsonProducts = json.decode(responseProducts.body);
        products.value = jsonProducts.map((data) {
          if (data['image'] != null && !data['image'].startsWith('http')) {
            data['image'] = '$baseUrl${data['image']}';
          }
          return Product.fromJson(data);
        }).toList();
      } else {
        isError(true);
        errorMessage('Gagal Memuat Produk');
        await fetchProduct();
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
      await fetchProduct();
    } finally {
      isLoading(false);
    }
  }

  Future<void> addProduct(Product product) async {
    final token = await authService.getToken();
    isLoading(true);

    if (product.image.isEmpty) {
      isError(true);
      errorMessage('Gambar adalah field yang wajib diisi.');
      isLoading(false);
      return;
    }

    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/products'));

    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toStringAsFixed(2);
    request.fields['category_id'] = product.categoryId.toString();

    var file = await http.MultipartFile.fromPath('image', product.image);
    request.files.add(file);

    request.headers['Authorization'] = 'Bearer $token';

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar('Sukses', 'Produk berhasil ditambahkan',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchProduct();
      } else {
        Get.snackbar('Gagal', 'Produk gagal ditambahkan',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProduct(int id, Product updatedProduct,
      {XFile? newImage}) async {
    final token = await authService.getToken();
    isLoading(true);

    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/products/$id'));
    request.fields['_method'] = 'PUT';

    request.fields['name'] = updatedProduct.name;
    request.fields['description'] = updatedProduct.description;
    request.fields['price'] = updatedProduct.price.toString();
    request.fields['category_id'] = updatedProduct.categoryId.toString();

    if (newImage != null) {
      File file = File(newImage.path);
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile('image', fileStream, length,
          filename: newImage.path.split('/').last);
      request.files.add(multipartFile);
    }
    request.headers['Authorization'] = 'Bearer $token';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updateProductWithNewImage = Product(
          id: updatedProduct.id,
          name: updatedProduct.name,
          description: updatedProduct.description,
          price: updatedProduct.price,
          categoryId: updatedProduct.categoryId,
          image: responseData['image_url'],
        );
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = updateProductWithNewImage;
          update();
        }
        Get.snackbar('Sukses', 'Produk berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
        await fetchProduct();
      } else {
        Get.snackbar('Gagal', 'Produk gagal diperbarui',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      throw Exception('Error updating product');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteProduct(int id) async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/products/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        products.removeWhere((product) => product.id == id);
        update();
        Get.snackbar('Sukses', 'Produk berhasil dihapus',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        isError(true);
        Get.snackbar('Gagal', 'Produk gagal dihapus',
            backgroundColor: Colors.red, colorText: Colors.white);
        errorMessage('Gagal Hapus Produk');
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  int getTotalProducts() {
    return products.length;
  }
}
