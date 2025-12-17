import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:view360/common/api_url/api_helper.dart';

class FilterResultController extends GetxController {
  var auctions = <dynamic>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasMore = true.obs;

  // Fetch Auctions
  Future<void> fetchAuctions({
    required int page,
    required int categoryID,
    bool append = false,
    bool prepend = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '$baseUrl/all_auctions?limit=10&page=$page&section=main&category=$categoryID',
      );

      print("category id: $categoryID");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> newData = data['data'] ?? [];
        if (newData.isEmpty && !append && !prepend) {
          errorMessage.value = 'No auctions available.';
          auctions.clear();
          hasMore.value = false;
        } else {
          if (prepend) {
            auctions.insertAll(0, newData);
          } else if (append) {
            auctions.addAll(newData);
          } else {
            auctions.assignAll(newData);
          }
          hasMore.value = newData.length == 10;
        }
      } else {
        errorMessage.value = 'Failed to load auctions';
        hasMore.value = false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred';
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
