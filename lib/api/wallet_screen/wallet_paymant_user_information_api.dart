import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final walletInformationUserMessageProvider = StateProvider<String>((ref) => '');

class WalletPaymantUserInformationApi {
  final userID = StateProvider<int>((ref) => 0);
  Future<dynamic> getwalletDetails(Ref ref, {required int userID}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final response = await ApiHelper().getMethod(
      url: '$baseUrl/users/$userID',
      headers: {'Authorization': 'Bearer ${pref.getString('token')}'},
    );
    try {
      if (response.statusCode == 200) {
        userID = pref.getInt('userID') ?? 0;
        return json.decode(response.body)['data'];
      } else {
        print(response.statusCode);
        debugPrint(response.body);
        ref.read(walletInformationUserMessageProvider.notifier).state = json
            .decode(response.body)['message'];
        return Future.error('Failed to load active auctions');
      }
    } on Exception catch (e) {
      print("error");
      debugPrint('$e');

      ApiHelper().handleNetworkException(e);
      ref.read(walletInformationUserMessageProvider.notifier).state =
          'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

final walletInformationDataProvider = Provider(
  (ref) => WalletPaymantUserInformationApi(),
);

final walletInformationResponseProvider = FutureProvider.family<dynamic, int>((
  ref,
  userID,
) async {
  final auctionService = ref.read(walletInformationDataProvider);
  return auctionService.getwalletDetails(ref, userID: userID);
});
