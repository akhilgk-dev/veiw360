import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';

class ForgotPasswordApi extends GetxController {
  final isLoading = false.obs;
  var success = false.obs;
  var message = ''.obs;
  Future<void> forgotPassword(String userId) async {
    isLoading.value = true;
    try {
      final response = await ApiHelper().postMethod(
        url: baseUrl + endpointForgotPassword,
        headers: await ApiHelper().headersWithToken(),
        body: jsonEncode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
        debugPrint('Password reset link sent successfully');
      } else {
        debugPrint(response.body);
        debugPrint('Error sending password reset link: ${response.statusCode}');
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint('Error sending password reset link: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
