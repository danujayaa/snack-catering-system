import 'dart:convert';
import 'package:get/get.dart';
import 'package:ordermobile/model/Category.dart';
import 'package:ordermobile/service/AuthService.dart';
import 'package:http/http.dart' as http;

class FetchDataCategory extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://yunna.soexma.com/api/categories';
  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    fetchCategory();
    super.onInit();
  }

  Future<void> fetchCategory() async {
    final token = await authService.getToken();
    isLoading(true);

    try {
      final responseCatgories = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (responseCatgories.statusCode == 200) {
        List<dynamic> jsonCategories = json.decode(responseCatgories.body);
        categories.value =
            jsonCategories.map((data) => Category.fromJson(data)).toList();
      } else {
        isError(true);
        errorMessage('Gagal Memuat Kategori');
      }
    } catch (e) {
      isError(true);
      errorMessage('Terjadi Kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }
}
