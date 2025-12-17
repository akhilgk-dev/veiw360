import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/model/authentication/phone_otp/phone_otp.dart';

import '../../../common/api_url/api_helper.dart';
import '../../../common/utils/network/http_api.dart';

class PhoneOtpApi extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;
  Future<void> sendOtp(OtpRequest model) async {
    isLoading.value = true;
    try {
      // send otp --------------------------------------------------------------
      final response = await ApiHelper().postMethod(
        url: baseUrl + endpointSendOtp,
        headers: ApiHelper().headersWithoutToken(),
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
      } else {
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
