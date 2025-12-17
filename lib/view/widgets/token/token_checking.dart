import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> tokenChecking() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  return token;
}

class TokenCheckingState extends GetxController {
  var token = ''.obs;

  void checkToken() async {
    token.value = await tokenChecking();
  }
}
