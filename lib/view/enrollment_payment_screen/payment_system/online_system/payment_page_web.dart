import 'package:flutter/material.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final Map<String, String> formData;

  const PaymentGatewayScreen({super.key, required this.formData});

  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            print("Navigating to: ${request.url}");
            print(request.url);
            if (request.url.contains("paymentcancel.htm")) {
              print("Payment was canceled by the user.");
              // You can also navigate back or show a dialog here
              //  Get.off(PaymentFailed());
              return NavigationDecision.navigate;
            }

            print('success url: ${request.url}');

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(_buildHtmlForm());
  }

  String _buildHtmlForm() {
    String actionUrl = "https://mzadcom.om/pg/HostedPaymentCoreSubmitMob.php";
    // "https://rop.mzadcom.om/pg/HostedPaymentCoreSubmitMob.php";
    String formHtml =
        """
    <html>
    <body onload="document.forms[0].submit();">
      <form action="$actionUrl" method="post">
    """;
    widget.formData.forEach((key, value) {
      formHtml += '<input type="hidden" name="$key" value="$value"/>';
    });
    formHtml += """
        <input type="submit" value="Proceed to Payment" style="display: none;"/>
      </form>
    </body>
    </html>
    """;
    return formHtml;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Payment Gateway'),
      body: WebViewWidget(controller: _controller),
    );
  }
}
