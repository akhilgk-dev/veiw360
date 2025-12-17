import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/api_url/api_helper.dart';

final messageFavouriteProvider = StateProvider<String>((ref) => '');

class FavouriteAuctionApi {
  Future<Map<String, dynamic>> getFavouriteAuctions(Ref ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final response = await ApiHelper().getMethod(
        url: baseUrl + whatchListEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
      );
      print(response.request);
      if (response.statusCode == 200) {
        ref.read(messageFavouriteProvider.notifier).state = jsonDecode(
          response.body,
        )['message'];
        return jsonDecode(response.body);
      } else {
        debugPrint(response.body);
        ref.read(messageFavouriteProvider.notifier).state = jsonDecode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } catch (e) {
      debugPrint('$e');

      ref.read(messageFavouriteProvider.notifier).state =
          'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

final favouriteAuctionProvider = Provider((ref) => FavouriteAuctionApi());

final favouriteAuctionResponseProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      final favouriteAuctionService = ref.read(favouriteAuctionProvider);
      return favouriteAuctionService.getFavouriteAuctions(ref);
    });
