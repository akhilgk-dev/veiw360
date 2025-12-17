import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:view360/language/language_controller.dart';
import 'package:view360/view/auction_details/auction_details_page.dart';
import 'package:view360/view/auction_details/url_launcher/whatsapp.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import 'package:view360/view/home/home_screen.dart';
import 'package:view360/view/splash_screen/animation_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final LanguageController languageController = Get.put(LanguageController());
  late final AppLinks _appLinks;
  late final StreamSubscription<Uri>? _linkSubscription;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  Uri? _initialUri;

  bool _handledLink = false;

  @override
  void initState() {
    super.initState();

    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      print('Deep link received: $uri');
      if (uri != null) {
        setState(() {
          _initialUri = uri;
          _handledLink = true; // 👈 mark as handled
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          return _handleIncomingLink();
        });
      }
    });

    // 👇 fallback in case no deep link comes in
    Future.delayed(const Duration(seconds: 0), () {
      if (!_handledLink) {
        print('No deep link handled. Navigating normally...');
        _loadLanguageAndNavigate();
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleIncomingLink() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (_initialUri != null) {
      final queryParams = _initialUri!.queryParameters;
      final auctionId = queryParams['auctionID'];
      final imageUrlRaw = queryParams['imageUrl'];
      // final token = queryParams['token'];
      final mainImage = queryParams['auctionImage'];
      final index = int.tryParse(queryParams['index'] ?? '0') ?? 0;

      try {
        final imageUrl = imageUrlRaw != null
            ? jsonDecode(Uri.decodeComponent(imageUrlRaw))
            : <dynamic>[];

        if (auctionId != null) {
          Get.to(
            () => AuctionDetailsPage(
              auctionId: int.parse(auctionId),
              imageUrl: imageUrl,
              token: token.toString(),
              index: index,
              mainImage: mainImage,
            ),
          );
        } else {
          print('Missing required parameters in deep link');
        }
      } catch (e) {
        print('Failed to decode imageUrl: $e');
      }

      _initialUri = null;
    } else {
      print('No deep link to process');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadLanguageAndNavigate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? savedLanguage = pref.getInt('language');

    if (savedLanguage != null) {
      languageController.selectedLanguage.value = savedLanguage;
      if (savedLanguage == 1) {
        Get.updateLocale(const Locale('ar'));
      } else {
        Get.updateLocale(const Locale('en'));
      }
    }

    //  Future.delayed(const Duration(seconds: 2), () {
    //     if (pref.containsKey('token')) {
    //       Get.off(() => BottomNav());
    //     } else {
    //       Get.off(() => LoginPage());
    //     }
    //   });

    Future.delayed(const Duration(seconds: 3), () {
      if (pref.containsKey('token')) {
        Get.off(
          () => UpgradeAlert(
            dialogStyle: GetPlatform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            onUpdate: () {
              GetPlatform.isIOS ? appstore() : playstore();

              return true;
            },
            upgrader: Upgrader(
              debugDisplayAlways: false,
              debugLogging: false,
              storeController: UpgraderStoreController(
                onAndroid: () => UpgraderPlayStore(),
                oniOS: () => UpgraderAppStore(),
              ),
            ),
            child:
                //BottomNav(),
                HomeScreen(),
          ),
        );
      } else {
        Get.off(
          () =>
              // BottomNav(),
              LoginPage(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 250,
              child: Image.asset(
                'assets/logo/view360_logo.jpeg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
    // AnimatedBackground(
    //   child: Column(
    //     children: [
    //       SizedBox(
    //         height: 75,
    //         width: 100,
    //         child: Image.asset(
    //           'assets/mzadcom_splash_logo.png',
    //           fit: BoxFit.fitWidth,
    //         ),
    //       ),
    //       const SizedBox(height: 20),
    //       LottieBuilder.asset(
    //         'assets/json/Loading.json',
    //         width: 150,
    //         height: 150,
    //         fit: BoxFit.fill,
    //       ),
    //     ],
    //   ),
    // );
  }
}
