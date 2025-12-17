import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/authentication/registration/registration.dart';

Future<dynamic> diologueBoxLogin(String text) {
  return Get.dialog(
    AlertDialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Login required for Enrollment'.tr),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Get.off(() {
              return LoginPage();
            });
          },
          child: Text('Login Now'.tr),
        ),
      ],
    ),
  );
}

//
Future<dynamic> diologueBox() {
  return Get.dialog(
    AlertDialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Verification required for Enrollment'.tr),
      content: Text(
        'Please check your email or phone to verify from the profile'.tr,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            SharedPrefsHelper.getString('token').then((value) {
              Get.to(() {
                return RegistrationScreen(checkPageID: 1, token: value);
              });
            });
          },
          child: Text('Verify Now'.tr),
        ),
      ],
    ),
  );
}
