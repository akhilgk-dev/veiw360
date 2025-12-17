import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/model/categorie_model/categorie_model.dart';

final messageProviderCategory = StateProvider<String>((ref) => '');

class CategorieApi {
  Future<CategoryModel> getCategoryList(Ref ref) async {
    try {
      debugPrint('Starting API call to fetch category list...');
      final response = await ApiHelper().getMethod(
        url: baseUrl + categoryListEndPoint,
        headers: ApiHelper().headersWithoutToken(),
      );
      debugPrint('API call completed with status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Parsing category list JSON...');
        return CategoryModel.fromJson(json.decode(response.body));
      } else {
        debugPrint('Error: Received status code ${response.statusCode}');
        final message = json.decode(response.body)['message'];
        debugPrint('Error message: $message');
        ref.read(messageProviderCategory.notifier).state = message;
        return Future.error('Failed to load active auctions');
      }
    } on Exception catch (e) {
      debugPrint('Exception occurred during API call: $e');
      ApiHelper().handleNetworkException(e);
      ref.read(messageProviderCategory.notifier).state =
          'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

final categoryModelProvider = Provider((ref) => CategorieApi());

final auctionResponseCategory = FutureProvider<CategoryModel>((ref) async {
  final categoryService = ref.read(categoryModelProvider);
  return categoryService.getCategoryList(ref);
});
