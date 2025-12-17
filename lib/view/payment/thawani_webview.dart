import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThawaniWebview extends StatefulWidget {
  const ThawaniWebview({
    super.key,
    required this.paymentUrl,
    this.onPaymentSuccess,
  });
  final String paymentUrl;
  final VoidCallback? onPaymentSuccess;

  @override
  State<ThawaniWebview> createState() => _ThawaniWebviewState();
}

class _ThawaniWebviewState extends State<ThawaniWebview> {
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

            // Check for success URL
            if (request.url.contains("success")) {
              print("Payment successful: ${request.url}");
              widget.onPaymentSuccess?.call();
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }

            // Check for cancel URL
            if (request.url.contains("cancel")) {
              print("Payment canceled: ${request.url}");
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
