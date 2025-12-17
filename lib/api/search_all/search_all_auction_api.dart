import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/view/home/widgets/categorie_list_auctions/categerie_widget.dart';
import 'package:view360/view/search/filter_drawer.dart';
import 'package:view360/view/search/search_and_viewall.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageProvider = StateProvider<String>((ref) => "");

class SearchAllAuctionsApi {
  Future<dynamic> searchAuction(
    Ref ref,
    String searchQuery,
    int? categoryId,
    String? auctionType,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final url = baseUrl + allAuctionEndpoint;
      final selectedCategory = categoryId != null
          ? '&category=$categoryId'
          : '';
      final selectedType = auctionType != null && auctionType.isNotEmpty
          ? '&type=$auctionType'
          : '';
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };
      final response = await ApiHelper().getMethod(
        url: "$url&text=$searchQuery$selectedCategory$selectedType",
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
        //AuctionResponse.fromJson(json.decode(response.body));
      } else {
        ref.read(messageProvider.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } catch (e) {
      ref.read(messageProvider.notifier).state = 'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

getType(int index) {
  switch (index) {
    case 0:
      return 'active';
    case 1:
      return 'upcoming';
    case 2:
      return 'previous';
    case 3:
      return 'direct';
    default:
      return '';
  }
}

final searchAllResponseProvider = FutureProvider<dynamic>((ref) async {
  final searchAllService = ref.read(searchAllauctionProvider);
  final searchQuery = ref.watch(searchAllProvider);
  final categoryId = ref.watch(selectedCategoryProvider);
  final selectedAuctionType = ref.watch(selectedAuctionTypeProvider);
  return searchAllService.searchAuction(
    ref,
    searchQuery,
    categoryId,
    getType(selectedAuctionType),
  );
});
final searchAllauctionProvider = Provider((ref) => SearchAllAuctionsApi());
