import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/BOW_enrollement_apis/online_payment_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/enrollment_models/online_payment_enrollment/online_payment_model.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/bank_transfer_widget_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/add_fund_to_wallet_online/add_fund_wallet_online.dart';
import '../../../../common/theme/colors.dart';
import '../../../../common/theme/style.dart';
import '../../widgets/terms_condition.dart';

class OnlinePaymentSystem extends StatelessWidget {
  OnlinePaymentSystem({
    super.key,
    required this.page,
    required this.checkboxProvider,
    required this.emailVerifiedAt,
    required this.phoneNumberVerifiedAt,
    required this.enrollName,
    this.auctionID,
    required this.isCompany,
    required this.guaranteeAmount,
    required this.civilID,
    required this.bankName,
    required this.accountNumber,
    required this.beneficiary,
    required this.enrollEmail,
    required this.termsAndCondition,
    this.groupID,
  });

  final StateProvider<bool> checkboxProvider;
  final String page;
  final String? emailVerifiedAt;
  final String? phoneNumberVerifiedAt;
  final String enrollName;
  final String enrollEmail;
  final int? auctionID;
  final double guaranteeAmount;
  final int isCompany;
  final String? civilID;
  final String? bankName;
  final String? accountNumber;
  final String beneficiary;
  final String termsAndCondition;
  final int? groupID;

  final PaymentController onlinePaymentApi = Get.put(PaymentController());

  final AddFundWalletOnlineAPI addFundWalletOnlineAPI = Get.put(
    AddFundWalletOnlineAPI(),
  );

  final amountController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  page == 'walletPage'
                      ? 'Add Funds to Wallet'.tr
                      : 'Online Payment Enrollment'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                height20,

                //------------------------------------------------------------------------------

                //checking which page coming, because wallet page need amount to add
                if (page == 'walletPage')
                  BankTransferTextField(
                    keyBOARD: TextInputType.numberWithOptions(decimal: true),
                    hinttext: 'Enter amount to add'.tr,
                    label: 'Amount to add'.tr,
                    validator: (p1) {
                      if (p1!.isEmpty) {
                        return 'Amount is required'.tr;
                      }
                      return null;
                    },
                    controller: amountController,
                  ),
                if (page == 'walletPage') height20,

                //---------------------------------------------------------------------
                // Image.asset('assets/images/omanarabbank.png'),
                height25,
                Text(
                  'Submitting this form will redirect\nyou to payment gateway.'
                      .tr,
                  style: smallFontSize12,
                  textAlign: TextAlign.center,
                ),
                height20,

                // Bank logo and info section
                if (bankName != null || accountNumber != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Placeholder for bank logo
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Image.asset(
                            'assets/images/thawani_logo.png',
                            width: 120,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (bankName != null)
                                Text(
                                  bankName!,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              if (accountNumber != null)
                                Text(
                                  'A/C: 0440061839220015',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                height25,

                // terms and condition
                TermsAndConditionWidget(
                  checkboxProvider: checkboxProvider,
                  termsAndCondition: termsAndCondition,
                  onChanged: (value) {
                    isChecked = value;
                  },
                ),
                height20,

                //button
                Center(
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
                          final localContext = context;
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          final userid = pref.getInt('userId');
                          //   print(accountNumber);

                          // if (emailVerifiedAt == null ||
                          //     phoneNumberVerifiedAt == null) {
                          //   diologueBox();
                          // }

                          if (page == 'walletPage') {
                            if (!formkey.currentState!.validate()) {
                              return;
                            }

                            // Validate input before parsing
                            final amountText = amountController.text.trim();

                            if (amountText.isEmpty ||
                                double.tryParse(amountText) == null ||
                                isChecked == false) {
                              // Optionally show an error message here
                              SnackbarHelperTop.showSnackBar(
                                context,
                                "Accept terms and conditions".tr,
                                color: AppStyle.secondColor,
                              );
                              return;
                            }

                            //adding 1.5% of the amount to the credit amount
                            final guaranteeAmountAfterServiceFee =
                                double.parse(amountText) +
                                (double.parse(amountText) * 1.5) / 100;
                            //credit amount + 1.5% of the credit amount
                            addFundWalletOnlineAPI.openPaymentGateway(
                              amountText,
                              // PaymentHeaderModel(
                              //   amount: double.parse(amountText),

                              // ),
                            );
                            // openPaymentGateway(double.parse(amountText).toString());
                            // final creditAmount = double.parse(amountText);
                            // final creditAmountAfterserviceFee =
                            //     creditAmount + (creditAmount * 1.5) / 100;
                            // final model = TransactionModel(
                            //     credit: creditAmountAfterserviceFee,
                            //     accountNumber:
                            //         int.tryParse(accountNumber.toString()) ?? 0,
                            //     bank: bankName.toString(),
                            //     method: 'online',
                            //     status: 'A',
                            //     type: 'wallet_recharge',
                            //     user: userid!);

                            // //   print("Wallet page----------------------$model");

                            // await addFundWalletOnlineAPI.addFundWalletOnline(model);
                          }
                          //if online
                          else {
                            //

                            //adding 1.5% of the amount to the guarantee amount
                            //guranteee amount + 1.5% of the guarantee amount
                            if (onlinePaymentApi.successPaymentStatus.value) {
                              SnackbarHelper.showSnackBar(
                                context,
                                'Payment successful'.tr,
                                color: Colors.green,
                              );
                              return;
                            }
                            if (isChecked == false) {
                              SnackbarHelperTop.showSnackBar(
                                context,
                                "Accept terms and conditions".tr,
                                color: AppStyle.secondColor,
                              );
                              return;
                            }

                            final guaranteeAmountAfterServiceFee =
                                guaranteeAmount + (guaranteeAmount * 1.5) / 100;

                            final model = OnlinePaymentModel(
                              auctionId: auctionID ?? 0,
                              enrollName: enrollName,
                              identityType: 'Civil card',
                              receiptNo: '',
                              bank: bankName.toString(),
                              accountNumber: accountNumber.toString(),
                              beneficiary: beneficiary,
                              isCompany: (isCompany == 0) ? false : true,
                              isOffline: false,
                              ptype: 'online',
                              amount: guaranteeAmountAfterServiceFee,
                            );

                            print(
                              "Online page----------------------${model.toJson()}",
                            );

                            //enroll type testing it need to be dynamic
                            if (localContext.mounted) {
                              print(guaranteeAmountAfterServiceFee);
                              // onlinePaymentApi.openPaymentGateway(
                              //   enrollName,
                              //   enrollEmail,
                              //   guaranteeAmountAfterServiceFee,
                              //   "enroll",
                              //   PaymentHeaderModel(
                              //     amount: guaranteeAmountAfterServiceFee
                              //         .toString(),
                              //     groupId: groupID,
                              //     auctionId: auctionID,
                              //     enrollId: "0",
                              //     isWalletRecharge: false,
                              //     ptype: 'online',
                              //     type: 'enroll',
                              //   ),

                              // );
                              await onlinePaymentApi.enrollUser(
                                localContext,
                                PaymentHeaderModel(
                                  amount: guaranteeAmountAfterServiceFee
                                      .toString(),
                                  groupId: groupID,
                                  auctionId: auctionID,
                                  enrollId: "0",
                                  isWalletRecharge: false,
                                  ptype: 'online',
                                  type: 'enroll',
                                ),
                                model,
                                type: 'enroll',
                                userName: enrollName,
                                userMail: enrollEmail,
                                auctionAmounttoPay:
                                    guaranteeAmountAfterServiceFee,
                              );
                            }
                          }
                        },
                        child: page == 'walletPage'
                            ? Obx(
                                () => addFundWalletOnlineAPI.loading.value
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: white,
                                          strokeWidth: 1,
                                        ),
                                      )
                                    : Text(
                                        "Save & Continue".tr,
                                        style: whiteStyle,
                                      ),
                              )
                            : Obx(() {
                                if (onlinePaymentApi.isLoading.value) {
                                  return SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: white,
                                      strokeWidth: 1,
                                    ),
                                  );
                                } else if (onlinePaymentApi
                                    .successPaymentStatus
                                    .value) {
                                  // Future.delayed(
                                  //   const Duration(milliseconds: 1000),
                                  //   () {
                                  //     Navigator.of(
                                  //       context,
                                  //     ).popUntil((route) => route.isFirst);
                                  //   },
                                  // );
                                  // SnackbarHelper.showSnackBar(
                                  //   context,
                                  //   'Payment successful'.tr,
                                  //   color: Colors.green,
                                  // );
                                  return Text(
                                    "Payment Successful".tr,
                                    style: whiteStyle,
                                  );
                                } else {
                                  return Text(
                                    "Save & Continue".tr,
                                    style: whiteStyle,
                                  );
                                }
                              }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
