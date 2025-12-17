import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtraTimeLiveCalling extends GetxController {
  var newExtraTime = DateTime.now().obs;
  var isLoading = false.obs;
  var message = ''.obs;

  Timer? _timer;
  bool _isActive = false;

  /// Start continuous polling
  void startExtraTimePolling(int auctionId, DateTime endTime) {
    // Check if within 2 minutes
    final now = DateTime.now();
    final difference = endTime.difference(now).inSeconds;

    // If NOT within 2 minutes — do NOT start polling
    if (difference > 120) {
      debugPrint("Not within 2 minutes. Polling NOT started.");
      return;
    }
    if (_isActive) return;

    _isActive = true;
    fetchExtraTime(auctionId); // immediate call

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_isActive) {
        fetchExtraTime(auctionId);
      }
    });
  }

  /// Stop polling
  void stopExtraTimePolling() {
    _isActive = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    stopExtraTimePolling();
    super.onClose();
  }

  /// Actual API call
  Future<void> fetchExtraTime(int auctionId) async {
    if (!_isActive) return;

    try {
      isLoading.value = true;

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response = await ApiHelper().postMethod(
        url: '$baseUrl/extra_time_check',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"auction": auctionId}),
      );

      if (response.statusCode == 200) {
        debugPrint('ExtraTime Body: ${jsonDecode(response.body)['data']['']}');
        final data = jsonDecode(response.body)['data'];

        if (data is Map && data.containsKey('end_date')) {
          newExtraTime.value = DateTime.parse(data['end_date']);
          message.value = "Updated";
        } else {
          message.value = "Invalid response: no end_date";
        }
      } else {
        message.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      message.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
