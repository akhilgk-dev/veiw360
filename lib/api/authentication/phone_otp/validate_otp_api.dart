import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/authentication/validate_otp/validate_otp_model.dart';

class ValidateOtpApi extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;
  Future<void> validateOtp(ValidateOtpModel model) async {
    isLoading.value = true;
    try {
      print(model.toJson());
      //validate otp --------------------------------------------------------------
      final response = await ApiHelper().postMethod(
        url: baseUrl + endpointValidateOtp,
        headers: ApiHelper().headersWithoutToken(),
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Token: ${jsonDecode(response.body)['data']['token']}');
        SharedPrefsHelper.saveString(
          'token',
          jsonDecode(response.body)['data']['token'],
        );
        SharedPrefsHelper.saveInt(
          'userId',
          jsonDecode(response.body)['data']['id'],
        );
        success.value = jsonDecode(response.body)['success'];
        // message.value = jsonDecode(response.body)['message'];
      } else {
        print(response.body);
        success.value = jsonDecode(response.body)['success'];
        // message.value = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      message.value = 'Error validating OTP: ${e.toString()}';
      success.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
