import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';

import '../../phone_number_otp/phone_number_otp.dart';

class PhoneNumberLogin extends StatelessWidget {
  const PhoneNumberLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      //  width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppStyle.blueButtonGradient),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            Get.to(() => PhoneNumberOtpPage());
          },
          child: Icon(Icons.phone_iphone_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
