import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/payment/payment_api.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/view/payment/thawani_webview.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentButton extends StatefulWidget {
  const PaymentButton({super.key});

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  final ThawaniPayController payment = Get.put(ThawaniPayController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Obx(() {
        //   return payment.isLoading.value
        //       ? CircularProgressIndicator()
        //       : payment.paymentUrl.value.isNotEmpty
        //       ? ThawaniWebview(paymentUrl: payment.paymentUrl.value)
        //       : Text("No Payment URL");
        // }),
        ElevatedButton(
          onPressed: () async =>
              //  webViewController.loadRequest(
              //   Uri.parse(
              //     'https://uatcheckout.thawani.om/pay/checkout_SiKk3rKXYyvredvnt6vDQMl0l2vEqxkBygrmrVb2ZP6uzLMuBu?key=rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
              //   ),
              // ),
              //print(payment.sessionId.value),
              await payment.initiatePayment(10).then((value) {
                print("Payment URL from button: $value");
                if (value.isNotEmpty) {
                  if (value.contains('http')) {
                    Get.to(ThawaniWebview(paymentUrl: value));
                  } else {
                    print("Invalid URL $value");
                  }
                }
              }),
          child: Text("Load WebView"),
        ),
      ],
    );
  }
}
