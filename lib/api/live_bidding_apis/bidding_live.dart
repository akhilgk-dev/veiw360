import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/live_bidding_apis/top_bidders.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiddingLiveAPI extends GetxController {
  var currentAmout = 0.obs;
  var success = false.obs;
  var loading = false.obs;
  var message = ''.obs;

  final TopBiddersApi topBiddersApi = Get.put(TopBiddersApi());

  Future<void> bidNow(int auctionId, String bidAmount) async {
    loading.value = true;
    final num totalBidAmount =
        num.parse(bidAmount) + topBiddersApi.highestBid.value;

    try {
      final body = {"auction": auctionId, "user_bid_amount": totalBidAmount};
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await ApiHelper().postMethod(
        url: baseUrl + userBidEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint(
          'Success bidding================================ ${response.body}',
        );

        final data = jsonDecode(response.body);
        message.value = data['message'] ?? '';
        success.value = data['success'];
        currentAmout.value = data['data']['current_amount'];
      } else {
        debugPrint('======================Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('==================Exception: $e');
    } finally {
      loading.value = false;
    }
  }
}
