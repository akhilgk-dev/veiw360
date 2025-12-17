import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final messageProvider = StateProvider<String>((ref) => '');

class EnrolledUsersCountApi {
  Future<dynamic> getEnrollCount(Ref ref, {required int groupId}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // API call to get Previous auctions
      final response = await http.get(
        Uri.parse(
          '$baseUrl/enrolled/users?page=1&limit=200&type=active&group=$groupId&client=1&status=A&group=$groupId',
        ),
        headers: {
          "Authorization": "Bearer ${pref.getString('token')}",
          "Content-Type": "application/json",
        },
      );

      //  print(response);

      if (response.statusCode == 200) {
        print('success==========');
        return json.decode(response.body);
      } else {
        debugPrint(response.body);
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

final enrollCountProvider = Provider((ref) => EnrolledUsersCountApi());

final auctionEnrollCount = FutureProvider.family<dynamic, int>((
  ref,
  groupId,
) async {
  final auctionService = ref.read(enrollCountProvider);
  return auctionService.getEnrollCount(ref, groupId: groupId);
});
