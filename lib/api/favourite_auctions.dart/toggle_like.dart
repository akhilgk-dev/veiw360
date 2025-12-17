import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToggleLikeGetX extends GetxController {
  final success = false.obs;
  final message = ''.obs;

  void toggleLike(int auctionID, String likeOrNot) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      final response = await ApiHelper().postMethod(
        url: baseUrl + toggleLikeendpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({"auction_id": auctionID, 'like': likeOrNot}),
      );

      print('response============================: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint(
          'success like===============================: ${response.body}',
        );
        success.value = jsonDecode(response.body)['success'];
        message.value = jsonDecode(response.body)['message'];

        print(success.value);
      } else {
        debugPrint(
          'Error in toggleLike=====================: ${response.statusCode}',
        );
        message.value = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      message.value = 'An error occurred: $e';
      debugPrint('Exception===================================: $e');
    }
  }
}
