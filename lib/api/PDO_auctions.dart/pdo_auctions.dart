import 'dart:convert';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pdoMessageProvider = StateProvider<String>((ref) => '');

class PDOAuctionsApi {
  Future<AuctionResponse> getPDOAuctions(Ref ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final url = token != null && token.isNotEmpty
          ? baseUrl + pdoLogged
          : baseUrl + pdoUnlogged;

      final headers = token != null && token.isNotEmpty
          ? {"Authorization": "Bearer $token"}
          : ApiHelper().headersWithoutToken();
      // API call to get PDO auctions
      final response = await ApiHelper().getMethod(url: url, headers: headers);

      if (response.statusCode == 200) {
        return AuctionResponse.fromJson(json.decode(response.body));
      } else {
        ref.read(pdoMessageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load PDO auctions');
      }
    } catch (e) {
      ref.read(pdoMessageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load PDO auctions');
    } finally {}
  }
}

final pdoAuctionProvider = Provider((ref) => PDOAuctionsApi());

final pdoAuctionResponseProvider = FutureProvider<AuctionResponse>((ref) async {
  final auctionService = ref.read(pdoAuctionProvider);
  return auctionService.getPDOAuctions(ref);
});
