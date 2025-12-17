import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WinningBidsApi {
  RxBool isLoading = false.obs;
  dynamic responseData;

  Future<void> fetchWinningbids() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    try {
      isLoading.value = true;
      // Simulate API call
      final response = await ApiHelper().getMethod(
        url: '$baseUrl$winningBidsEndpoint?page=1&limit=100',
        headers: await ApiHelper().headersWithToken(),
      );
      if (response.statusCode == 200) {
        responseData = jsonDecode(response.body);
      } else {
        isLoading.value = false;
        debugPrint('Failed to load winning bids: ${response.statusCode}');
      }

      isLoading.value = false;
    } catch (e) {
      debugPrint('error in winning bids: $e');
    }
  }
}
