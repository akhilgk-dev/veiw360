import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/enrollment_models/wallet_payment_enrollment/wallet_payment_model.dart';
import 'package:view360/view/enrollment_payment_screen/payment_system/wallet_system/add_fund_screen.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import '../../../../api/BOW_enrollement_apis/wallet_payment_api.dart';
import '../../../../common/theme/colors.dart';
import '../../../../common/theme/sized_box.dart';
import '../../../../common/theme/style.dart';

class WalletPayamntSystem extends ConsumerWidget {
  WalletPayamntSystem({
    super.key,
    required this.balance,
    required this.emailVerifiedAt,
    required this.phoneNumberVerifiedAt,
    required this.guaranateeAmount,
    required this.civilID,
    required this.bankName,
    required this.accountNumber,
    required this.beneficiary,
    required this.enrollName,
    required this.auctionID,
    required this.isCompany,
    required this.userMail,
    required this.fileIdNumber,
  });

  final dynamic balance;
  final String userMail;
  final String? emailVerifiedAt;
  final String? phoneNumberVerifiedAt;
  final String guaranateeAmount;
  final String enrollName;
  final int auctionID;
  final int isCompany;
  final String civilID;
  final String bankName;
  final String accountNumber;
  final String beneficiary;
  final String fileIdNumber;
  final WalletPaymentApi walletPaymentApi = Get.put(WalletPaymentApi());
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double balanceAmount = double.tryParse(balance.toString()) ?? 0.0;
    final double guaranteeAmount = double.tryParse(guaranateeAmount) ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          key: const ValueKey(true),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppStyle.bidButtonGradient),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.account_balance_wallet, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                "Available Balance".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$balance OMR",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return InkWell(
                        onTap: () async {
                          Get.to(
                            () => AddFundScreen(
                              emailVerifiedAt: emailVerifiedAt,
                              phoneNumberVerifiedAt: phoneNumberVerifiedAt,
                              addFund: 'addFund',
                              accountNumber: accountNumber,
                              auctionID: auctionID,
                              bankName: bankName,
                              beneficiary: beneficiary,
                              civilID: civilID,
                              enrollName: enrollName,
                              isCompany: isCompany,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: yelloAccent),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(Icons.wallet, color: darkBlue),
                                width05,
                                Text('Add Funds'.tr, style: smallFontSize12),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        height10,

        //checking balance is 0 or not
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              balance == null ||
                  balance == '0' ||
                  balanceAmount < guaranteeAmount
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppStyle.gray),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Your request cannot be processed due to insufficient funds in your wallet. Please try using an alternative payment method.'
                          .tr,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(darkBlue),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (emailVerifiedAt == null ||
                              phoneNumberVerifiedAt == null ||
                              accountNumber.isEmpty ||
                              fileIdNumber.isEmpty) {
                            diologueBox();
                          }

                          ref.invalidate(
                            auctionAllDetailsResponseProvider(auctionID),
                          );

                          final model = WalletPaymentModel(
                            receiptNumber: '',
                            auctionId: auctionID,
                            enrollName: enrollName,
                            identityType: 'Civil Card',
                            civilId: civilID,
                            bank: bankName,
                            accountNumber: accountNumber,
                            beneficiary: beneficiary,
                            isCompany: false,
                            isOffline: true,
                            ptype: 'wallet',
                            amount: guaranteeAmount,
                          );

                          Get.defaultDialog(
                            title: "Warning",
                            middleText:
                                "Are you sure you want to proceed with this payment?",
                            textConfirm: "Yes",
                            textCancel: "No",
                            onConfirm: () async {
                              await walletPaymentApi.walletPaymentApi(model);

                              Get.back();

                              if (walletPaymentApi.success.value) {
                                Get.back();

                                ref.invalidate(
                                  auctionAllDetailsResponseProvider(auctionID),
                                );

                                Get.snackbar(
                                  'Success'.tr,
                                  'Payment Successful'.tr,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.green,
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  duration: Duration(seconds: 3),
                                );
                              } else {
                                SnackbarHelper.showSnackBar(
                                  context,
                                  'Payment Failed!, Please check with registration time or contact admin'
                                      .tr,
                                  color: Colors.red,
                                );
                              }
                            },
                            onCancel: () {
                              Get.back();
                            },
                          );

                          // if (walletPaymentApi.success.value) {
                          //   Get.back();

                          //   Get.snackbar('Success'.tr, 'Payment Successful'.tr,
                          //       colorText: white,
                          //       backgroundColor: Colors.green);
                          // } else {
                          //   SnackbarHelper.showSnackBar(
                          //       context,
                          //       'Payment Failed!, Please check with registartion time or contact admin'
                          //           .tr,
                          //       color: darkRed);
                          // }
                        },
                        child: Obx(
                          () => walletPaymentApi.isLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: white,
                                    strokeWidth: 1,
                                  ),
                                )
                              : Text("Pay now".tr, style: whiteStyle),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
