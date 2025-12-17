import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:view360/model/previous_auction/previous_auction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageProvider = StateProvider<String>((ref) => '');

class PreviousAuctionsApi {
  Future<AuctionResponse> getPreviousAuctions(Ref ref) async {
    print("Previous Auction Api Call ${baseUrl + previousAuctionEndPoint}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // API call to get Previous auctions
      final response = await ApiHelper().getMethod(
        url: (token != null && token.isNotEmpty)
            ? baseUrl + previousAuctionEndPoint + "?limit=10"
            : baseUrl + previousAuctions,
        headers: token != null && token.isNotEmpty
            ? {"Authorization": "Bearer $token"}
            : ApiHelper().headersWithoutToken(),
      );
      print("Previous Auction Response: ${response.statusCode}");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return AuctionResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        ref.read(messageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load previus auctions');
      }
    } catch (e) {
      print(e);

      ref.read(messageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load previus auctions');
    } finally {}
  }
}

final previousauctionProvider = Provider((ref) => PreviousAuctionsApi());

final auctionResponseProviderPrevious = FutureProvider<AuctionResponse>((
  ref,
) async {
  final auctionService = ref.read(previousauctionProvider);
  return auctionService.getPreviousAuctions(ref);
});
