import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/language/language_controller.dart';

import '../payment_system/wallet_system/add_fund_screen.dart';
import '../registration_for_bidders.dart';

class SelectablePaymentMethodWidget extends StatelessWidget {
  SelectablePaymentMethodWidget({
    super.key,
    required this.ref,
    required this.selectedPaymentMethod,
    this.addfund,
    //online,wallt,bank
    this.paymentTypes = const [true, true, true],
  });

  final WidgetRef ref;
  final String selectedPaymentMethod;
  final String? addfund;
  final LanguageController languageController = Get.find<LanguageController>();
  List<bool> paymentTypes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.secondary.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(50),
      ),
      width: double.infinity,

      //adding 2 container for banktransfer and online payment
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (paymentTypes[0])
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (addfund != 'addFund') {
                      ref
                              .read(
                                selectedPaymentMethodProviderForRegistration
                                    .notifier,
                              )
                              .state =
                          'Online';
                    } else {
                      ref.read(selectedAddfundwallet.notifier).state = 'Online';
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: selectedPaymentMethod == 'Online'
                          ? AppStyle.secondColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 40,
                    child: Center(
                      child: Text(
                        'Online Payment'.tr,
                        style: TextStyle(
                          color: selectedPaymentMethod == 'Online'
                              ? Colors.white
                              : AppStyle.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (addfund != 'addFund')
              if (paymentTypes[1])
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ref
                              .read(
                                selectedPaymentMethodProviderForRegistration
                                    .notifier,
                              )
                              .state =
                          'Wallet';
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: selectedPaymentMethod == 'Wallet'
                            ? AppStyle.secondColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 40,
                      child: Center(
                        child: Text(
                          'Wallet'.tr,
                          style: TextStyle(
                            color: selectedPaymentMethod == 'Wallet'
                                ? Colors.white
                                : AppStyle.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            if (paymentTypes[2])
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (addfund != 'addFund') {
                      ref
                              .read(
                                selectedPaymentMethodProviderForRegistration
                                    .notifier,
                              )
                              .state =
                          'Bank';
                    } else {
                      ref.read(selectedAddfundwallet.notifier).state = 'Bank';
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: selectedPaymentMethod == 'Bank'
                          ? AppStyle.secondColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 40,
                    child: Center(
                      child: Text(
                        'Bank Transfer'.tr,
                        style: TextStyle(
                          color: selectedPaymentMethod == 'Bank'
                              ? Colors.white
                              : AppStyle.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
