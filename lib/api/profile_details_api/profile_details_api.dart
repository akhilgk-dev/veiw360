import 'package:view360/model/profile_details/profile_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProviderProfile = StateProvider<String>((ref) => '');

class ProfileDetailsApi {
  Future<ProfileDetailsModel> getPreviousAuctions(Ref ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userid = prefs.getInt('userId') ?? '';

    try {
      // API call to get Previous auctions
      final response = await ApiHelper().getMethod(
        url: userid == ''
            ? baseUrl + profileEndpoint
            : '$baseUrl/users/$userid',
        headers: {'Authorization': 'Bearer ${prefs.getString('token') ?? ''}'},
      );

      if (response.statusCode == 200) {
        // print('Profile Details Response: ${response.body}');
        print(json.decode(response.body)['data']);

        return ProfileDetailsModel.fromJson(json.decode(response.body));
      } else {
        // print(response.body);
        ref.read(messageProviderProfile.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } catch (e) {
      ref.read(messageProviderProfile.notifier).state = 'An error occurred: $e';
      return Future.error('An error occurred: $e');
    } finally {}
  }
}

final profileauctionProvider = Provider((ref) => ProfileDetailsApi());

final auctionResponseProviderProfile = FutureProvider<ProfileDetailsModel>((
  ref,
) async {
  final auctionService = ref.read(profileauctionProvider);
  return auctionService.getPreviousAuctions(ref);
});
