import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/mzadcom_payment/mzad_payment_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MzadcomPaymentApi extends GetxController {
  RxBool isLoading = false.obs;

  Future<MzadPaymentResponse> fetchPaymentDetails(String status) async {
    try {
      isLoading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await ApiHelper().getMethod(
        url: '$baseUrl$mzadcomPayment?page=1&limit=50&status=$status',
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        isLoading.value = false;
        return MzadPaymentResponse(
          success: false,
          message: 'Error: ${response.statusCode}',
          data: [],
          meta: Meta.empty(),
        );
      }
      isLoading.value = false;
      return MzadPaymentResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      isLoading.value = false;
      print('Exception in fetchPaymentDetails: $e');
      return MzadPaymentResponse(
        success: false,
        message: e.toString(),
        data: [],
        meta: Meta.empty(),
      );
    }
  }
}
