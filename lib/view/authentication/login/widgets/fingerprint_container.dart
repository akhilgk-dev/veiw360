import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';

import '../../../../common/theme/sized_box.dart';

class FingerprintContainerWidget extends StatelessWidget {
  const FingerprintContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          width10,
          GetPlatform.isIOS
              ? SvgPicture.asset(
                  'assets/splash/face-recognition.svg',
                  height: 60,
                  width: 50,
                  colorFilter: ColorFilter.mode(
                    AppStyle.primary,
                    BlendMode.srcIn,
                  ),
                )
              // Image.asset(
              //     'assets/images/png-clipart-iphone-x-computer-icons-face-id-android-text-monochrome-removebg-preview.png',
              //     width: 100,
              //     height: 70,
              //     color: AppStyle.white,
              //   )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: AppStyle.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.fingerprint,
                      size: 30,
                      color: AppStyle.white2,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
