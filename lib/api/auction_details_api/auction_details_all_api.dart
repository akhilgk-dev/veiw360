import 'dart:convert';
import 'dart:async';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionDetailsPageApi {
  Future<dynamic> getAuctionDetailsInfo(
    Ref ref, {
    required int auctionId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      print("this is calling infinately");
      final isAuthenticated = token != null && token.isNotEmpty;
      final url = isAuthenticated
          ? '$baseUrl/logged_auctions/$auctionId'
          : '$baseUrl/auctions/$auctionId';

      final headers = isAuthenticated
          ? {'Authorization': 'Bearer $token'}
          : ApiHelper().headersWithoutToken();
      // API call to get Previous auctions
      final response = await ApiHelper().getMethod(url: url, headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body)['data'];
      } else {
        print('Error: ${response.statusCode}');
        return Future.error('Failed to load Auction details');
      }
    } catch (e) {
      print(e);
      return Future.error('Failed to load Auction details');
    } finally {}
  }
}

final auctionDetailsProvider = Provider((ref) => AuctionDetailsPageApi());

final auctionAllDetailsResponseProvider = FutureProvider.family<dynamic, int>((
  ref,
  auctionId,
) async {
  final auctionService = ref.read(auctionDetailsProvider);
  return auctionService.getAuctionDetailsInfo(ref, auctionId: auctionId);
});
