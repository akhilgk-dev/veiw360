import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_url/api_helper.dart';
import '../../../../common/utils/network/http_api.dart';

class EmailVerificationApi extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;

  Future<bool> sendEmailOtp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoading.value = true;
    try {
      // send otp --------------------------------------------------------------
      final response = await ApiHelper().postMethod(
        url: baseUrl + emailOtpEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        debugPrint('response.body: ${response.body}');
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
        return true;
      } else {
        debugPrint('response.body: ${response.body}');
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
        return false;
      }
    } catch (e) {
      debugPrint('$e');
      throw Exception('Error sending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

//------------------------------------------------------------------------------

class ValidateEmailOTP extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;

  Future<void> validateEmailOtp(OtpSendEmailModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoading.value = true;
    try {
      // send otp --------------------------------------------------------------
      final response = await ApiHelper().postMethod(
        url: baseUrl + emailValidateOtpEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        debugPrint('response.body: ${response.body}');
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
      } else {
        debugPrint('response.body: ${response.body}');
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      debugPrint('$e');
      throw Exception('Error sending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class OtpSendEmailModel {
  final String otp;
  final String type;

  OtpSendEmailModel({required this.otp, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'type': type,
    };
  }

  factory OtpSendEmailModel.fromJson(Map<String, dynamic> json) {
    return OtpSendEmailModel(
      otp: json['otp'],
      type: json['type'],
    );
  }
}
