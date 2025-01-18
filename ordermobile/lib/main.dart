import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/page/SplashScreen.dart';
import 'package:ordermobile/routes/page_routes.dart';
import 'package:get/get.dart';
import 'package:ordermobile/service/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initService();
  runApp(const MyApp());
}

Future<void> initService() async {
  Get.put(AuthService());
  Get.put(AuthController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        getPages: pageRouteApp.pages);
  }
}
