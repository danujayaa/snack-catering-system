import 'package:get/get.dart';
import 'package:ordermobile/components/ChangeAddress.dart';
import 'package:ordermobile/controller/FetchDataUser.dart';
import 'package:ordermobile/page/AboutScreen.dart';
import 'package:ordermobile/page/EditProfile.dart';
import 'package:ordermobile/page/admin/payment/DetailPaymentAdminScreen.dart';
import 'package:ordermobile/page/admin/payment/PaymentScreen.dart';
import 'package:ordermobile/page/admin/order/DetailOrderAdminScreen.dart';
import 'package:ordermobile/page/admin/order/EditStatusOrderScreen.dart';
import 'package:ordermobile/page/admin/product/AddProductScreen.dart';
import 'package:ordermobile/page/admin/product/EditProductScreen.dart';
import 'package:ordermobile/page/admin/product/ProductScreen.dart';
import 'package:ordermobile/page/user/address/AddAddress.dart';
import 'package:ordermobile/page/user/address/AddressScreen.dart';
import 'package:ordermobile/page/user/address/EditAddress.dart';
import 'package:ordermobile/page/user/order/DetailOrderScreen.dart';
import 'package:ordermobile/page/user/DetailProductScreen.dart';
import 'package:ordermobile/page/GetStarted.dart';
import 'package:ordermobile/page/user/CartScreen.dart';
import 'package:ordermobile/page/LoginScreen.dart';
import 'package:ordermobile/page/Navbar.dart';
import 'package:ordermobile/page/RegisterScreen.dart';
import 'package:ordermobile/page/SplashScreen.dart';
import 'package:ordermobile/page/admin/order/OrderScreen.dart';
import 'package:ordermobile/page/admin/UserScreen.dart';
import 'package:ordermobile/page/user/PaymentScreen.dart';
import 'package:ordermobile/routes/route_name.dart';

class pageRouteApp {
  static final pages = [
    GetPage(
      name: RouteName.splashscreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: RouteName.getstarted,
      page: () => const GetStarted(),
    ),
    GetPage(
      name: RouteName.registerscreen,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: RouteName.loginscreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: RouteName.navbar,
      page: () => const NavBar(),
    ),
    GetPage(
      name: RouteName.detailproduct,
      page: () => DetailProduct(),
    ),
    GetPage(
      name: RouteName.keranjang,
      page: () => const CartScreen(
        userId: 0,
        addressId: 0,
        tglAntar: '',
        jam: '',
        catatan: '',
      ),
    ),
    GetPage(
      name: RouteName.detailorder,
      page: () => DetailOrderScreen(order: Get.arguments),
    ),
    GetPage(
      name: RouteName.editprofile,
      page: () => const EditProfileScreen(),
      binding: FetchUserBinding(),
    ),
    GetPage(
      name: RouteName.alamatpengiriman,
      page: () => AddressScreen(),
    ),
    GetPage(
      name: RouteName.addalamat,
      page: () => AddAddress(),
    ),
    GetPage(
      name: RouteName.editalamat,
      page: () => EditAddress(
        address: Get.arguments,
      ),
    ),
    GetPage(
      name: RouteName.ubahalamat,
      page: () => ChangeAddress(),
    ),
    GetPage(
      name: RouteName.tentang,
      page: () => const AboutScreen(),
    ),
    GetPage(
      name: RouteName.pembayaran,
      page: () => PaymentScreen(),
    ),
    GetPage(
      name: RouteName.pembayaranadmin,
      page: () => PaymentScreenAdmin(),
    ),
    GetPage(
      name: RouteName.detailpembayaranadmin,
      page: () => DetailPaymentScreen(
        payment: Get.arguments,
      ),
    ),
    GetPage(
      name: RouteName.productadmin,
      page: () => ProductAdminScreen(),
    ),
    GetPage(
      name: RouteName.addproductadmin,
      page: () => const AddProductPage(),
    ),
    GetPage(
      name: RouteName.editproductadmin,
      page: () => EditProductPage(
        product: Get.arguments,
      ),
    ),
    GetPage(
      name: RouteName.useradmin,
      page: () => UserAdminScreen(),
    ),
    GetPage(
      name: RouteName.orderadmin,
      page: () => OrderAdminScreen(),
    ),
    GetPage(
      name: RouteName.detailorderadmin,
      page: () => DetailAdminOrderScreen(
        order: Get.arguments,
      ),
    ),
    GetPage(
      name: RouteName.editstatusorderadmin,
      page: () => EditOrderStatusScreen(
        order: Get.arguments,
      ),
    ),
  ];
}
