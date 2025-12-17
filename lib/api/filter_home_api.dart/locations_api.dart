import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/model/filter_model_in_home/locations/locations_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageProviderlocation = StateProvider<String>((ref) => '');

class LocationsApi {
  Future<LocationResponse> getlocationList(Ref ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // API call to get location list
      final response = await ApiHelper().getMethod(
        url: baseUrl + locationEndpoint,
        headers: {'Authorization': 'Bearer ${pref.getString('token')!}'},
      );

      if (response.statusCode == 200) {
        return LocationResponse.fromJson(json.decode(response.body));
      } else {
        debugPrint(response.statusCode.toString());
        ref.read(messageProviderlocation.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint('$e');

      ref.read(messageProviderlocation.notifier).state =
          'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

final locationModelProvider = Provider((ref) => LocationsApi());
final auctionResponselocation = FutureProvider<LocationResponse>((ref) async {
  final locationService = ref.read(locationModelProvider);
  return locationService.getlocationList(ref);
});
