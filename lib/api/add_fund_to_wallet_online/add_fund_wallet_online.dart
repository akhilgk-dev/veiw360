import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/payment/payment_api.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/add_fund_wallet_online/add_fund_wallet_online_model.dart';
import 'package:view360/view/payment/thawani_webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_url/api_helper.dart';

//add fund to wallet online api
class AddFundWalletOnlineAPI extends GetxController {
  var loading = false.obs;
  var success = false.obs;
  var message = ''.obs;

  Future<void> addFundWalletOnline(TransactionModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    loading(true);
    try {
      final response = await ApiHelper().postMethod(
        url: baseUrl + walletEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        success.value = jsonDecode(response.body)['success'];
        if (success.value) {
          openPaymentGateway(model.credit.toString());
        }
      } else {
        message.value =
            jsonDecode(response.body)['message'] ?? 'Failed to add fund';
      }
    } catch (e) {
      message.value = 'An error occurred: $e';
    } finally {
      loading(false);
    }
  }

  void openPaymentGateway(String creditAmount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userId = pref.getInt('userId');
    final ThawaniPayController payment = Get.put(ThawaniPayController());

    // Prepare the form data
    // final formData = {
    //   'amount': creditAmount,
    //   'udf1': userId.toString(),
    //   'udf2': 'wallet',
    //   'udf3': '',
    //   'udf4': '',
    //   'udf5': '',
    //   // 'success_url':
    //   //     'https://test.rop.mzadcom.om/wallet-payment-success/?ptype=online&type=wallet_recharge&amt=$creditAmount',
    //   // 'cancel_url': 'https://test.rop.mzadcom.om/wallet-payment-cancelled',
    // };

    // final formData = {
    //   'amount': creditAmount,
    //   'udf1': userId.toString(),
    //   'udf2': 'walletRecharge',
    //   // 'udf3': 'wallet_mobile',
    //   // 'udf4': 'mobile_app',
    //   // 'udf5': '',
    //   // 'success_url':
    //   //     'https://test.rop.mzadcom.om/wallet-payment-success/?ptype=online&type=wallet_recharge&amt=$creditAmount',
    //   // 'cancel_url': 'https://test.rop.mzadcom.om/wallet-payment-cancelled',
    // };
    final guaranteeAmountAfterServiceFee =
        double.parse(creditAmount) + (double.parse(creditAmount) * 1.5) / 100;
    print(
      "Amount guaranteeAmountAfterServiceFee is ££££££££ $guaranteeAmountAfterServiceFee",
    );
    await payment.initiatePayment((guaranteeAmountAfterServiceFee)).then((
      value,
    ) {
      if (value.isNotEmpty) {
        Get.to(
          ThawaniWebview(
            paymentUrl:
                '${thawaniBaseUrl!}/pay/${value['data']['session_id']}?key=$thawaniPublicKey',
            onPaymentSuccess: () {
              debugPrint("Payment successful callback triggered.");

              // You can add additional logic here if needed
              successPayment(
                PaymentHeaderModel(
                  amount: creditAmount,
                  reference: userId.toString(),
                  invoice: value['data']['invoice'] ?? '',
                  type: 'wallet_recharge',
                  ptype: 'online',
                ),
              );
            },
          ),
        );
      } else {
        debugPrint("Invalid URL $value");
      }
    });
    // // Navigate to WebView
    // Get.to(
    //   () =>
    //       PaymentButton(),
    //       PaymentGatewayScreen(formData: formData),
    // );
  }

  void successPayment(PaymentHeaderModel paymentHeader) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${pref.getString('token')}', // Replace with actual token logic
      };

      final body = jsonEncode({
        'group_id': paymentHeader.groupId,
        'auction_id': paymentHeader.auctionId,
        'enroll_id': paymentHeader.enrollId,
        'gatePass': paymentHeader.gatePass,
        'amount': paymentHeader.amount,
        'invoice': paymentHeader.invoice,
        'reference': paymentHeader.reference,
        'type': paymentHeader.type,
        'is_wallet_recharge': paymentHeader.isWalletRecharge,
        'ptype': paymentHeader.ptype,
      });

      final response = await ApiHelper().postMethod(
        url: baseUrl + updatePaymentStatusEndpoint,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('Payment status updated successfully: $responseData');
      } else {
        debugPrint('Failed to update payment status: ${response.statusCode}');
      }

      // Handle response if needed
    } catch (e) {
      debugPrint("Error in successPayment: $e");
    }
  }
}

class PaymentHeaderModel {
  final int? groupId;
  final int? auctionId;
  final String? enrollId;
  final String? gatePass;
  final String amount;
  final String? invoice;
  final String? reference;
  final String? type;
  final bool isWalletRecharge;
  final String? ptype;

  PaymentHeaderModel({
    this.groupId,
    this.auctionId,
    this.enrollId,
    this.gatePass,
    required this.amount,
    this.invoice,
    this.reference,
    this.type,
    this.isWalletRecharge = true,
    this.ptype,
  });
}
