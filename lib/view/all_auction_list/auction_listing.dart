// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:view360/api/payment/payment_api.dart';
// import 'package:view360/common/api_url/api_helper.dart';
// import 'package:view360/view/payment/thawani_webview.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class Paymentchcheck extends StatefulWidget {
//   const Paymentchcheck({super.key});

//   @override
//   State<Paymentchcheck> createState() => _PaymentchcheckState();
// }

// class _PaymentchcheckState extends State<Paymentchcheck> {
//   final ThawaniPayController payment = Get.put(ThawaniPayController());
//   getThawani() async {}
//   WebViewController webViewController = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('https://thw.om/success')) {
//             print('blocking navigation to $request}');
//             return NavigationDecision.prevent;
//           }
//           print('allowing navigation to $request');
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..setUserAgent(
//       'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
//     )
//     ..loadRequest(
//       Uri.parse(
//         '$thawaniBaseUrl/pay/checkout_PXdyW7GKY1G5BEMaq3q2Mn9P3I1emFmjXWnC6YZJUwI4V256Sz?key=$thawaniPublicKey',
//       ),
//     );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Payment Check")),
//       body: Center(
//         child: Column(
//           children: [
//             Text("This is the Payment Check Screen"),
//             ElevatedButton(
//               onPressed: () {
//                 payment.initiatePayment(10);
//               },
//               child: Text("Get thawani"),
//             ),
//             Obx(() {
//               if (payment.paymentUrl.value.isNotEmpty) {
//                 print(payment.sessionId.value);

//                 return Text("Payment URL: ${payment.paymentUrl.value}");
//               } else {
//                 return Text("No Payment URL");
//               }
//             }),
//             ElevatedButton(
//               onPressed: () async =>
//                   //  webViewController.loadRequest(
//                   //   Uri.parse(
//                   //     'https://uatcheckout.thawani.om/pay/checkout_SiKk3rKXYyvredvnt6vDQMl0l2vEqxkBygrmrVb2ZP6uzLMuBu?key=rRQ26GcsZzoEhbrP2HZvLYDbn9C9et',
//                   //   ),
//                   // ),
//                   //print(payment.sessionId.value),
//                   await payment.initiatePayment(10).then((value) {
//                     print("Payment URL from button: $value");
//                     if (value.isNotEmpty) {
//                       if (value.contains('http')) {
//                         Get.to(ThawaniWebview(paymentUrl: value));
//                       } else {
//                         print("Invalid URL $value");
//                       }
//                     }
//                   }),
//               child: Text("Load WebView"),
//             ),
//             ElevatedButton(
//               onPressed: () => print(thawaniAPIKey),
//               child: Text("Load sdfas"),
//             ),
//             Text(payment.sessionId.value),
//           ],
//         ),
//       ),
//     );
//   }
// }
