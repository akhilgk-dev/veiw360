import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageProviderAllAuctionApi = StateProvider<String>((ref) => '');

class AllAuctionListApi {
  Future<dynamic> getAllAuctionList(Ref ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // API call to get Previous auctions
      final response = await http.get(
        Uri.parse(baseUrl + allAuctionEndpoint),
        headers: {
          "Authorization": "Bearer ${pref.getString('token')}",
          "Content-Type": "application/json",
        },
      );
      print('Calling All Auction List API: ' + baseUrl + allAuctionEndpoint);

      // print(response);

      if (response.statusCode == 200) {
        print('All Auction List API status: ${response.statusCode}');

        return json.decode(response.body);
      } else {
        debugPrint("this response ${response.body}");
        ref.read(messageProviderAllAuctionApi.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load previous auctions');
      }
    } on Exception catch (e) {
      ref.read(messageProviderAllAuctionApi.notifier).state =
          'An error occurred: $e';
      ApiHelper().handleNetworkException(e);
      debugPrint('$e');

      return Future.error('Failed to load Group list auctions');
    }
  }
}

final allAuctionsListProvider = Provider((ref) => AllAuctionListApi());

final auctionResponseAllAuctions = FutureProvider<dynamic>((ref) async {
  final auctionService = ref.read(allAuctionsListProvider);
  return auctionService.getAllAuctionList(ref);
});
