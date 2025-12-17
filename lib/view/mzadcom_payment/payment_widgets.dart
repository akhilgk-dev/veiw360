import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/mzadcom_payment/payment_options_screeen.dart';

//payment tab bar widget
class PaymentOptionTabBar extends StatelessWidget {
  final PaymentOptionsController controller;

  const PaymentOptionTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: AppStyle.secondColor,
          boxShadow: [
            BoxShadow(
              color: AppStyle.darkGolden.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedTab.value = 0,
                child: Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: controller.selectedTab.value == 0
                        ? Colors.white
                        : AppStyle.secondColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Wallet'.tr,
                      style: TextStyle(
                        color: controller.selectedTab.value == 0
                            ? AppStyle.primary
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedTab.value = 1,
                child: Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: controller.selectedTab.value == 1
                        ? Colors.white
                        : AppStyle.secondColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Bank Transfer'.tr,
                      style: TextStyle(
                        color: controller.selectedTab.value == 1
                            ? AppStyle.primary
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
