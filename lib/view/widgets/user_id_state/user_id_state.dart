import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserIdState extends GetxController {
  final userid = 0.obs;

  Future setUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('userId') ?? 0;
    userid.value = id;
  }
}
