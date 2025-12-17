//remember me state

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberMeState extends GetxController {
  var rememberMe = false.obs;
  var username = ''.obs;
  var password = ''.obs;

  @override
  void onInit() async {
    remember();
    super.onInit();
  }

  void remember() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getBool('remember_me') ?? false;

    // print("remeber=======================================${rememberMe.value}");

    if (rememberMe.value == true) {
      username.value = pref.getString('username') ?? '';
      password.value = pref.getString('password') ?? '';

      // print(
      //     "username==========================================${username.value}");
      // print(password.value);
    }
  }
}
