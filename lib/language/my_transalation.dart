import 'package:get/get.dart';
import 'package:view360/language/english_arabic.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUs, 'ar_SA': arSa};
}
