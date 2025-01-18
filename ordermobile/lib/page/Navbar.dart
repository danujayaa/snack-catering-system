import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataUser.dart';
import 'package:ordermobile/page/user/HomeScreen.dart';
import 'package:ordermobile/page/user/order/OrderScreen.dart';
import 'package:ordermobile/page/ProfileScreen.dart';
import 'package:ordermobile/page/admin/DashboardScreen.dart';
import 'package:ordermobile/page/admin/payment/PaymentScreen.dart';
import 'dart:io';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  late List<Widget> _screens = [];
  final FetchDataUser fetchDataUser = Get.put(FetchDataUser());
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  Future<void> _initializeScreens() async {
    await fetchDataUser.fetchUserLogin();
    setState(() {
      if (fetchDataUser.user.value.role == 'superadmin') {
        _screens = [
          DashboardScreen(),
          PaymentScreenAdmin(),
          ProfileScreen(),
        ];
      }
      if (fetchDataUser.user.value.role == 'admin') {
        _screens = [
          DashboardScreen(),
          ProfileScreen(),
        ];
      }
      if (fetchDataUser.user.value.role == 'user') {
        _screens = [
          HomeScreen(),
          const OrderScreen(),
          ProfileScreen(),
        ];
      }
      _selectedIndex = _selectedIndex < _screens.length ? _selectedIndex : 0;
    });
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null ||
        now.difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = now;
      _showCustomSnackBar();
      return false;
    }
    if (Platform.isAndroid) {
      exit(0);
    }
    return true;
  }

  void _showCustomSnackBar() {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50,
        left: MediaQuery.of(context).size.width / 5,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Tekan lagi untuk keluar aplikasi',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFF8F9FD),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          unselectedLabelStyle: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          selectedItemColor: const Color(0xff7F714F),
          unselectedItemColor: const Color(0xff3d3d3d),
          onTap: (int index) {
            setState(() {
              if (index >= 0 && index < _screens.length) {
                _selectedIndex = index;
              }
            });
          },
          currentIndex: _selectedIndex,
          items: fetchDataUser.user.value.role == 'superadmin'
              ? [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icon/home.svg'),
                    activeIcon: SvgPicture.asset('assets/icon/homeclick.svg'),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icon/payment.svg'),
                    activeIcon:
                        SvgPicture.asset('assets/icon/paymentclick.svg'),
                    label: 'Pembayaran',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icon/profile.svg'),
                    activeIcon:
                        SvgPicture.asset('assets/icon/profileclick.svg'),
                    label: 'Profile',
                  ),
                ]
              : fetchDataUser.user.value.role == 'admin'
                  ? [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icon/home.svg'),
                        activeIcon:
                            SvgPicture.asset('assets/icon/homeclick.svg'),
                        label: 'Dashboard',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icon/profile.svg'),
                        activeIcon:
                            SvgPicture.asset('assets/icon/profileclick.svg'),
                        label: 'Profile',
                      ),
                    ]
                  : [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icon/home.svg'),
                        activeIcon:
                            SvgPicture.asset('assets/icon/homeclick.svg'),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icon/order.svg'),
                        activeIcon:
                            SvgPicture.asset('assets/icon/orderclick.svg'),
                        label: 'Pesanan',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/icon/profile.svg'),
                        activeIcon:
                            SvgPicture.asset('assets/icon/profileclick.svg'),
                        label: 'Profile',
                      ),
                    ],
        ),
        body: _screens.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _screens[_selectedIndex],
      ),
    );
  }
}
