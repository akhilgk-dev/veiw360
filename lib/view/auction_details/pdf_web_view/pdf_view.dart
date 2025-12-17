import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String page;
  bool isPayment;

  PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.page,
    this.isPayment = false,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Define platform-specific creation parameters
    PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      // iOS-specific settings
      params =
          WebKitWebViewControllerCreationParams.fromPlatformWebViewControllerCreationParams(
            params,
          );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      // Android-specific settings
      params =
          AndroidWebViewControllerCreationParams.fromPlatformWebViewControllerCreationParams(
            params,
          );
    }

    // Initialize WebViewController with platform-specific parameters
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            Center(child: CircularProgressIndicator());
            // Handle loading progress
            print('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          // onHttpError: (HttpResponseError error) {
          //   print('HTTP error: ${error.description}');
          // },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          widget.isPayment
              ? widget.pdfUrl
              : 'https://docs.google.com/gview?embedded=true&url=${widget.pdfUrl}',
        ),
      );

    // Access platform-specific implementations
    if (_controller.platform is WebKitWebViewController) {
      final WebKitWebViewController webKitController =
          _controller.platform as WebKitWebViewController;
      webKitController.setAllowsBackForwardNavigationGestures(true);
    } else if (_controller.platform is AndroidWebViewController) {
      final AndroidWebViewController androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            _launchInBrowser(Uri.parse(widget.pdfUrl));
          },
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: darkBlue,
                border: Border.all(width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Download PDF'.tr, style: whiteStyle),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.download, color: white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppbarWidget(title: widget.page),
      body: Column(
        children: [Expanded(child: WebViewWidget(controller: _controller))],
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
