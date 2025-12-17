import 'dart:convert';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/active_auctions/active_auctions_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageProvider = StateProvider<String>((ref) => '');

class ActiveAuctionsApi {
  Future<AuctionResponse> getActiveAuctions(Ref ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    try {
      final url = token != null && token.isNotEmpty
          ? baseUrl + activeloggedAuction
          : baseUrl + activeAuctionEndpoint;

      final headers = token != null && token.isNotEmpty
          ? {"Authorization": "Bearer $token"}
          : ApiHelper().headersWithoutToken();
      // API call to get active auctions
      final response = await ApiHelper().getMethod(url: url, headers: headers);

      print(response);

      if (response.statusCode == 200) {
        print("ssssss");
        return AuctionResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        ref.read(messageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } catch (e) {
      print(e);

      ref.read(messageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    } finally {}
  }
}

final activeauctionProvider = Provider((ref) => ActiveAuctionsApi());

final auctionResponseProvider = FutureProvider<AuctionResponse>((ref) async {
  final auctionService = ref.read(activeauctionProvider);
  return auctionService.getActiveAuctions(ref);
});
