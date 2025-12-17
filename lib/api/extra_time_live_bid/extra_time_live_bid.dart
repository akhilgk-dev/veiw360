import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtraTimeLiveBid extends GetxController {
  var newExtraTime = DateTime.now().obs;

  void extraTimeBid(int auctionId) async {
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
      debugPrint('Response Body: ${response.body}');
      final data = jsonDecode(response.body)['data'];
      if (data is Map && data.containsKey('end_date')) {
        newExtraTime.value = DateTime.parse(data['end_date']);
        debugPrint('New Bid: ${newExtraTime.value}');
      } else {
        debugPrint('Error: Missing or invalid "end_date" in data');
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
    }
  }

  Future<DateTime> getExtraTime(int auctionId) async {
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
      debugPrint('Response Body: ${response.body}');
      final data = jsonDecode(response.body)['data'];
      if (data is Map && data.containsKey('end_date')) {
        newExtraTime.value = DateTime.parse(data['end_date']);
        debugPrint('New Bid: ${newExtraTime.value}');
        return DateTime.parse(data['end_date']);
      } else {
        debugPrint('Error: Missing or invalid "end_date" in data');
        return DateTime.now().subtract(Duration(days: 1));
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      return DateTime.now().subtract(Duration(days: 1));
    }
  }
}
