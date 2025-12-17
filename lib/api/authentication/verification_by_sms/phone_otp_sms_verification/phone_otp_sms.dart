import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_url/api_helper.dart';
import '../../../../common/utils/network/http_api.dart';

class PhoneOtpSmsVerify extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;

  Future<bool> sendSMSOtp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoading.value = true;
    try {
      // send otp --------------------------------------------------------------
      final response = await ApiHelper().postMethod(
        url: baseUrl + phonenumberVerificationSmsEndpoint,
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

class ValidatePhoneSMSOTP extends GetxController {
  var isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;

  Future<void> validateSMSPhoneOtp(OtpSendPhoneModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoading.value = true;
    try {
      // send otp --------------------------------------------------------------
      final response = await ApiHelper().postMethod(
        url: baseUrl + phonenumberVerificationOtpEndpoint,
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

class OtpSendPhoneModel {
  final String otp;
  final String type;

  OtpSendPhoneModel({required this.otp, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'type': type,
    };
  }

  factory OtpSendPhoneModel.fromJson(Map<String, dynamic> json) {
    return OtpSendPhoneModel(
      otp: json['otp'],
      type: json['type'],
    );
  }
}
