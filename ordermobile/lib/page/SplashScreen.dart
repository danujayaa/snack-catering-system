import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ordermobile/controller/AuthController.dart';
import 'package:ordermobile/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      await authController.checkLoginStatus();
      if (authController.isLoggedIn.value) {
        Get.toNamed(RouteName.navbar);
      } else {
        Get.toNamed(RouteName.getstarted);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4D4136),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SvgPicture.asset("assets/img/logo_white.svg")],
        ),
      ),
    );
  }
}
