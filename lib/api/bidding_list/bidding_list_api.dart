import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageProvider = StateProvider<String>((ref) => '');

class BiddingListApi {
  Future<dynamic> getGroupAuctionList(Ref ref, {required int groupId}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var url = '$baseUrl/grouped_auctions?group=$groupId';
      // API call to g
      //finalet Previous auctions
      final response = await http.get(
        Uri.parse(url),

        // Uri.parse('$baseUrl/auctions_by_group/$groupId'),
        headers: {
          "Authorization": "Bearer ${pref.getString('token')}",
          "Content-Type": "application/json",
        },
      );

      //  print(response);

      if (response.statusCode == 200) {
        // print("new");

        return json.decode(response.body);
      } else {
        debugPrint(response.body);
        ref.read(messageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load previous auctions');
      }
    } catch (e) {
      debugPrint('$e');
      ref.read(messageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load Group list auctions');
    }
  }
}

final groupListProvider = Provider((ref) => BiddingListApi());

final auctionResponseGroup = FutureProvider.family<dynamic, int>((
  ref,
  groupId,
) async {
  final auctionService = ref.read(groupListProvider);
  return auctionService.getGroupAuctionList(ref, groupId: groupId);
});

// for gustUser---------------------------------------------------------------

final messageProviderGuest = StateProvider<String>((ref) => '');

class BiddingListApiGuest {
  Future<dynamic> getGroupAuctionListGuest(
    Ref ref, {
    required int groupId,
  }) async {
    try {
      // API call to get Previous auctions
      final response = await http.get(
        Uri.parse('$baseUrl/grouped_auctions?group=$groupId'),
      );

      //  print(response);

      if (response.statusCode == 200) {
        print("new");
        return json.decode(response.body);
      } else {
        debugPrint(response.statusCode.toString());
        ref.read(messageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load previous auctions');
      }
    } catch (e) {
      debugPrint('$e');
      ref.read(messageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load Group list auctions');
    }
  }
}

final groupListProviderGuest = Provider((ref) => BiddingListApiGuest());

final auctionResponseGroupGuest = FutureProvider.family<dynamic, int>((
  ref,
  groupId,
) async {
  final auctionService = ref.read(groupListProviderGuest);
  return auctionService.getGroupAuctionListGuest(ref, groupId: groupId);
});
