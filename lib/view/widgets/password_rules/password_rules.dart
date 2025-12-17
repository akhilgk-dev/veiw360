import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';

import '../../../common/theme/colors.dart';

class PasswordRulesWidget extends StatelessWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> passwordRules = [
      'Password must contain at least 8 characters'.tr,
      'Password must contain at least one uppercase letter'.tr,
      'Password must contain at least one lowercase letter'.tr,
      'Password must contain at least one number'.tr,
      'Password must contain at least one special character'.tr,
    ];

    return Column(
      children: List.generate(
        passwordRules.length,
        (index) => Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.done, size: 12, color: Colors.green),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  passwordRules[index],
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordRules extends StatelessWidget {
  const PasswordRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Get.dialog(
              AlertDialog(
                backgroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Password rules'.tr),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [PasswordRulesWidget()],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Close'.tr),
                  ),
                ],
              ),
            );
          },
          child: Icon(CupertinoIcons.info),
          // Text(
          //   'See rules'.tr,
          //   style: TextStyle(color: AppStyle.primary),
          // ),
        ),
      ],
    );
  }
}
