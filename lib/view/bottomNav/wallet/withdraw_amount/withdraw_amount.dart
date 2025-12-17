import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/wallet_screen/wallet_paymant_user_information_api.dart';
import 'package:view360/api/wallet_screen/wallet_screen_api.dart'
    show transationResponseProvider;
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/view/widgets/user_id_state/user_id_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawAmountFromWallet extends ConsumerWidget {
  final String walletAmount;
  WithdrawAmountFromWallet({super.key, required this.walletAmount});

  final WithdrawAmountApi withdrawAmountApi = Get.put(WithdrawAmountApi());
  final TextEditingController amountController = TextEditingController();
  final UserIdState userid = Get.put((UserIdState()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Withdraw from Wallet'.tr,
                  style: headingTextStyle17.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: darkBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                height10,
                Text(
                  'Enter the amount you wish to withdraw'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                height20,
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount'.tr;
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 1) {
                      return 'Amount not less than 1'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Amount'.tr,
                    hintText: 'e.g., 500.00'.tr,
                    prefixIcon: Icon(
                      Icons.account_balance_wallet,
                      color: darkBlue,
                    ),
                    labelStyle: TextStyle(color: darkBlue),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: darkBlue, width: 2),
                    ),
                  ),
                ),
                height30,
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: darkBlue.withOpacity(0.3),
                    ),
                    onPressed: () async {
                      _handleWithdraw(context, ref);
                    },
                    child: Obx(
                      () => withdrawAmountApi.loading.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Proceed to Withdraw'.tr,
                              style: whiteStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
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

  void _handleWithdraw(BuildContext context, WidgetRef ref) async {
    if (double.parse(amountController.text) < 1) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Amount not less than 1'.tr,
        color: darkRed,
      );
      return;
    }

    if (amountController.text.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter an amount'.tr,
        color: darkRed,
      );
      return;
    }

    final userId = await SharedPrefsHelper.getInt('userId');
    if (userId == null) {
      SnackbarHelperTop.showSnackBar(
        context,
        'User not found. Please log in again.'.tr,
        color: darkRed,
      );
      return;
    }

    final enteredAmount = double.tryParse(amountController.text);
    final walletBalance = double.tryParse(walletAmount);

    if (enteredAmount != null &&
        walletBalance != null &&
        enteredAmount > walletBalance) {
      SnackbarHelperTop.showSnackBar(
        context,
        'No enough balance in your account, add fund to your wallet'.tr,
      );
      return;
    }

    try {
      await withdrawAmountApi.withdrawAmountFromWallet(
        userid: userId,
        debit: amountController.text,
      );

      if (withdrawAmountApi.success.value) {
        ref.invalidate(walletInformationDataProvider);
        ref.invalidate(transationResponseProvider);
        user(ref);

        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Amount withdrawn successfully'.tr,
            color: Colors.green,
          );
          amountController.clear();
        }
      } else {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            withdrawAmountApi.message.value.isNotEmpty
                ? withdrawAmountApi.message.value.tr
                : 'Something went wrong, please try again'.tr,
            color: Colors.red,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(
          context,
          'An error occurred. Please try again later.'.tr,
          color: Colors.red,
        );
      }
    }
  }

  Future<void> user(WidgetRef ref) async {
    userid.setUserId();

    ref.invalidate(walletInformationResponseProvider(userid.userid.value));
    Get.back();
  }
}

class WithdrawAmountApi extends GetxController {
  var loading = false.obs;
  var success = false.obs;
  var message = ''.obs;

  Future<void> withdrawAmountFromWallet({
    required int userid,
    required String debit,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    loading(true);
    // Api call to withdraw amount from wallet

    final response = await ApiHelper().postMethod(
      url: '$baseUrl/wallet_transaction',
      headers: {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "no_balance_update": false,
        "user": userid,
        "type": "withdraw",
        "debit": debit,
        "credit": 0,
        "status": "W",
        "method": "offline",
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      success.value = jsonDecode(response.body)['success'];
      loading(false);
      // print(success.value);
    } else {
      //print(response.body);
      //print(response.statusCode);
      message.value = jsonDecode(response.body)['message'];
      loading(false);
    }
  }
}
