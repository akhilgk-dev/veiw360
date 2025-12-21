import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';

import '../../../common/theme/colors.dart';
import '../../../language/language_controller.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  AppbarWidget({super.key, required this.title, this.onBackPress});
  final LanguageController languageController = Get.put(LanguageController());
  final void Function()? onBackPress;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppStyle.bidButtonGradient),
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          // ),
        ),
        child: AppBar(
          actions: [
            //Transalation icon
            TransalatorIcon(),
            width15,
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (onBackPress != null) {
                  onBackPress!();
                }
              },
              child: CircleAvatar(
                backgroundColor: white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: languageController.selectedLanguage.value == 1
                        ? 10
                        : 0,
                  ),
                  child: Icon(Icons.arrow_back_ios, size: 15),
                ),
              ),
            ),
          ),
          title: Text(title),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//
//

class AppbarWidgetWithoutBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const AppbarWidgetWithoutBackButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        //Transalation icon
        TransalatorIcon(),
        width15,
      ],
      automaticallyImplyLeading: false,
      backgroundColor: AppStyle.secondary,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TransalatorIcon extends StatelessWidget {
  TransalatorIcon({super.key});
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        languageController.languageProcessed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 45,
        width: 50,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Image.asset(
              "assets/splash/arabi_eng.png",

              // Text(
              //   languageController.selectedLanguage.value == 1
              //       ? 'عربي'
              //       : 'EN',
              //   style: bold.copyWith(fontSize: 12, color: black),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
