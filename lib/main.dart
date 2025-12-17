import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:view360/api/server_time/server_time.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/language/my_transalation.dart';
import 'package:view360/view/widgets/appError/app_error.dart';

import 'view/splash_screen/splash_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
void main() async {
  await dotenv.load(fileName: ".env");
  ErrorWidget.builder = (_) => Directionality(
    textDirection: TextDirection.ltr,
    child: const AppErrorWidget(),
  );
  Get.put(ServerTime());
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      translations: MyTranslations(),
      debugShowCheckedModeBanner: false,
      title: 'Mzadcom Auction Platform',
      theme: ThemeData(
        cardColor: white,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: white),
        primaryColorLight: white,
        cardTheme: const CardThemeData(color: white),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: white),
          titleTextStyle: TextStyle(
            color: white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        primaryColor: white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: SplashScreen(),
    );
  }
}
