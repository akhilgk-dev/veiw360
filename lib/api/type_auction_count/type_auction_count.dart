import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';

class TypeAuctionCountAPI extends GetxController {
  var loading = false.obs;

  var activeCount = 0.obs;
  var upcomingCount = 0.obs;
  var previusCount = 0.obs;
  var directSaleCount = 0.obs;

  void initialize() {
    countRequest();
  }

  void countRequest() async {
    loading.value = true;

    try {
      var response = await ApiHelper().getMethod(
        url: baseUrl + typesAuctionCountEndpoint,
        headers: await ApiHelper().headersWithToken(),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        activeCount.value = data['active'] ?? 0;
        upcomingCount.value = data['upcoming'] ?? 0;
        previusCount.value = data['previous'] ?? 0;
        directSaleCount.value = data['direct'] ?? 0;

        debugPrint('successs');
      } else {
        print('Error fetching auction counts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching auction counts: $e');
    } finally {
      loading.value = false;
    }
  }
}
