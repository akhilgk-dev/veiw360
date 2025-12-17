import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:view360/model/enrollment_models/wallet_payment_enrollment/wallet_payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_url/api_helper.dart';
import '../../common/utils/network/http_api.dart';

class WalletPaymentApi extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var errorMessage = ''.obs;

  Future<void> walletPaymentApi(WalletPaymentModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading.value = true;
      final response = await ApiHelper().postMethod(
        url: baseUrl + enrollBankTransferEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      print(jsonEncode(model.toJson()));

      if (response.statusCode == 200) {
        print(response.body);
        debugPrint('online payment response: ${response.body}');

        success.value = await jsonDecode(response.body)['success'];

        //  if (success.value == true) {}
      } else {
        debugPrint('online payment error: ${response.statusCode}');
        print('online payment error: ${response.body}');
        errorMessage.value =
            jsonDecode(response.body)['message'] ?? 'Payement Failed';
      }
    } catch (e) {
      debugPrint('$e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
