import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/mzadcom_payment/mzad_wallet_payment.dart';
import 'package:view360/api/wallet_screen/wallet_paymant_user_information_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/formatter/amount_formate.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/enrollment_payment_screen/payment_system/wallet_system/add_fund_screen.dart';
import 'package:view360/view/mzadcom_payment/payment_bottom_sheet.dart';

class WalletPaymentWidget extends ConsumerWidget {
  WalletPaymentWidget({
    super.key,
    required this.userId,
    required this.totalAmount,
    required this.selectedAuctions,
  });
  final int userId;
  final double totalAmount;
  final List<SelectedAuction> selectedAuctions;
  final MzadWalletPayment walletPaymentApi = Get.put(MzadWalletPayment());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(walletInformationResponseProvider(userId));
    return walletData.when(
      data: (data) {
        final balance = data['wallet_amount'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Text(
              "Total Amount: ${AmountFormate().withDecimal(totalAmount.toString())}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            height15,

            // ListView(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   children: [
            //     for (var auction in selectedAuctions)
            //       ListTile(
            //         title: Text("Auction ID: ${auction.auction.groupName}"),
            //         subtitle: Text("Amount: ${auction.amount}"),
            //       ),
            //   ],
            // ),
            Container(
              key: const ValueKey(true),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppStyle.bidButtonGradient,
                ),
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
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
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
                        "${AmountFormate().withDecimal(data['wallet_amount'])} OMR",
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
                                  emailVerifiedAt: data['email_verified_at'],
                                  phoneNumberVerifiedAt:
                                      data['mobile_verified_at'],
                                  addFund: 'addFund',
                                  accountNumber: data['account_number'] ?? '',
                                  auctionID: 0,
                                  bankName: data['bank'] ?? '',
                                  beneficiary: data['beneficiary'] ?? '',
                                  civilID: data['file_id_number'] ?? '',
                                  enrollName: data['name'] ?? '',
                                  isCompany: data['is_company'],
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
                                    Text(
                                      'Add Funds'.tr,
                                      style: TextStyle(
                                        color: darkBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                      (double.tryParse(balance) ?? 0.0) < totalAmount
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
                              if (data['account_number'] == null) {
                                SnackbarHelperTop.showSnackBar(
                                  context,
                                  'Please update your profile to enroll.'.tr,
                                  color: AppStyle.secondColor,
                                );
                                return;
                              }
                              (walletPaymentApi.success.value ||
                                      walletPaymentApi.isLoading.value)
                                  ? null
                                  : walletPaymentApi.walletPayment(
                                      totalAmount,
                                      selectedAuctions,
                                    );
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
                                  : walletPaymentApi.success.value
                                  ? Text(
                                      "Payment Successful".tr,
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      "Pay now".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
