import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/model/upcoming_auctions/upcoming_auctions_model.dart';

final messageProvider = StateProvider<String>((ref) => '');

class UpcomingAuctionsApi {
  Future<UpcomingAuctionResponse> getUpcomingAuctions(Ref ref) async {
    try {
      // API call to get Upcoming auctions
      final response = await ApiHelper().getMethod(
        url: baseUrl + upcomingAuctionEndPoint,
        headers: ApiHelper().headersWithoutToken(),
      );

      if (response.statusCode == 200) {
        return UpcomingAuctionResponse.fromJson(json.decode(response.body));
      } else {
        debugPrint(response.body);
        ref.read(messageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load Upcoming auctions');
      }
    } catch (e) {
      debugPrint('error: $e');

      ref.read(messageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load Upcoming auctions');
    } finally {}
  }
}

final upcomingauctionProvider = Provider((ref) => UpcomingAuctionsApi());

final auctionResponseProviderUpcoming = FutureProvider<UpcomingAuctionResponse>(
  (ref) async {
    final auctionService = ref.read(upcomingauctionProvider);
    return auctionService.getUpcomingAuctions(ref);
  },
);
