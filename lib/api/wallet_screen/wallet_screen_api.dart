import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/view/bottomNav/wallet/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final transactionMessageProvider = StateProvider<String>((ref) => '');
final Map<String, dynamic> meta = {};

class WalletScreenApi {
  Future<dynamic> getTransactionDetails(
    Ref ref,
    String? transactionType,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final id = pref.getInt('userId');

    final response = await ApiHelper().getMethod(
      url: "$baseUrl$walletEndpoint?customer=$id&trans_type=$transactionType",
      headers: {'Authorization': 'Bearer ${pref.getString('token')}'},
    );
    try {
      if (response.statusCode == 200) {
        meta.addAll(json.decode(response.body)['meta']);
        print(meta);
        print(response.request);
        return json.decode(response.body)['data'];
      } else {
        debugPrint(response.body);
        ref.read(transactionMessageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } catch (e) {
      print("error----------------------------------------");
      debugPrint('$e');
      // ApiHelper().handleNetworkException(e);
      ref.read(transactionMessageProvider.notifier).state =
          'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

final transactionDataProvider = Provider((ref) => WalletScreenApi());

final transationResponseProvider = FutureProvider<dynamic>((ref) async {
  final auctionService = ref.read(transactionDataProvider);
  final transactionType = ref.watch(transactionTypeProvider);
  return auctionService.getTransactionDetails(ref, transactionType);
});
