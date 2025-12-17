import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 0.obs;
  var languageBool = false.obs;

  // Retrieve the saved language when the app starts
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void languageBoolFun() {
    languageBool.value = !languageBool.value;
  }

  // Method to select a new language
  void selectLanguage(int language) {
    selectedLanguage.value = language;
    _saveLanguageToPreferences(language);
  }

  // Save the selected language to SharedPreferences
  void _saveLanguageToPreferences(int language) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('language', language);
  }

  // Load the saved language from SharedPreferences
  void _loadSavedLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? savedLanguage = pref.getInt('language');
    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
    }
  }

// Method to change the language
  void checkingLanguage() {
    if (selectedLanguage.value == 1 && languageBool.value == true) {
      Get.updateLocale(const Locale('ar'));
    } else {
      Get.updateLocale(const Locale('en'));
    }
  }

  void languageProcessed() {
    languageBoolFun();
    if (languageBool.value == true) {
      selectLanguage(1);
    } else {
      selectLanguage(0);
    }

    checkingLanguage();
  }
}
// 0 means english
//1 means arabic
