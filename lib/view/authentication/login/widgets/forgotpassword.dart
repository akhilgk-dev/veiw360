import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';

import '../../forgot_password/forgot_password_page.dart';

class ForhotPasswordAndRememberMe extends StatelessWidget {
  const ForhotPasswordAndRememberMe({
    super.key,
    required this.ischeckBoxProvider,
  });

  final StateProvider<bool> ischeckBoxProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final isCheckBox = ref.watch(ischeckBoxProvider);
                final isChecked = ref.watch(ischeckBoxProvider);
                return SizedBox(
                  height: 40,
                  child: Checkbox(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fillColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) => isCheckBox ? AppStyle.primary : Colors.white,
                    ),
                    value: isChecked,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(ischeckBoxProvider.notifier).state = value;
                      }
                    },
                  ),
                );
              },
            ),
            Text(
              'Remember me?'.tr,
              style: TextStyle(
                color: AppStyle.lightPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPassword()),
            );
          },
          child: Text(
            'Forgot Password?'.tr,
            style: TextStyle(
              fontSize: 15,
              color: AppStyle.lightPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
