import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordermobile/controller/FetchDataOrder.dart';
import 'package:ordermobile/controller/FetchDataPayment.dart';
import 'package:ordermobile/routes/route_name.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatelessWidget {
  final FetchDataPayment fetchDataPayment = Get.put(FetchDataPayment());
  final FetchDataOrder fetchDataOrder = Get.put(FetchDataOrder());
  PaymentScreen({super.key});

  Future<void> handlePaymentStatus(String status, String orderId) async {
    Map<String, dynamic> notificationData = {
      'order_id': orderId,
      'transaction_status': status,
    };

    await fetchDataPayment.handlePaymentNotif(notificationData);
    if (status == 'settlement') {
      await fetchDataOrder.updateOrder(int.parse(orderId), 'pending');
    } else if (status == 'pending') {
      await fetchDataOrder.updateOrder(int.parse(orderId), 'unpaid');
    }

    await fetchDataOrder.fetchOrder();
    Get.offAllNamed(RouteName.navbar);
  }

  bool shouldPreventNavigation(String url) {
    return url.contains('success') ||
        url.contains('settlement') ||
        url.contains('pending') ||
        url.contains('deny') ||
        url.contains('cancel') ||
        url.contains('error') ||
        url.contains('failed') ||
        url.contains('expire');
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    if (args == null ||
        args is! Map<String, dynamic> ||
        args['snapToken'] == null ||
        args['orderId'] == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pembayaran Error')),
        body: const Center(child: Text('Data Pembayaran Tidak Valid')),
      );
    }

    final String snapToken = args['snapToken'];
    final String orderId = args['orderId'].toString();

    final controller = WebViewController()
    //mengatur mode javascript
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken'))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _handlePaymentRedirect(url, orderId);
          },
          onPageFinished: (String url) async {
            if (url.contains('status_code=500') || url.contains('error')) {
              Get.snackbar(
                'Terjadi Kesalahan',
                'Server mengalami masalah, coba lagi nanti.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
              Get.offAllNamed(RouteName.navbar);
            } else {
              _handlePaymentRedirect(url, orderId);
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;

            if (shouldPreventNavigation(url)) {
              _handlePaymentRedirect(url, orderId);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          'Pembayaran',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color(0xff3d3d3d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.offAllNamed(RouteName.navbar);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }

  void _handlePaymentRedirect(String url, String orderId) async {
    if (url.contains('success') || url.contains('settlement')) {
      await handlePaymentStatus('settlement', orderId);
    } else if (url.contains('pending')) {
      await handlePaymentStatus('pending', orderId);
    } else if (url.contains('deny') || url.contains('failed')) {
      await handlePaymentStatus('deny', orderId);
    } else if (url.contains('cancel')) {
      await handlePaymentStatus('cancel', orderId);
    } else if (url.contains('expire')) {
      await handlePaymentStatus('expire', orderId);
    }
  }
}
