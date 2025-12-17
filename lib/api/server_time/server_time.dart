import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';

class ServerTime extends GetxController {
  var loading = false.obs;

  var serverTime = ''.obs;

  void initialize() {
    serverTimeNow();
  }

  void serverTimeNow() async {
    loading.value = true;

    try {
      var response = await ApiHelper().getMethod(
        url: baseUrl + servertimeEndPoint,
        headers: await ApiHelper().headersWithToken(),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        serverTime.value = data['server_time'];
        debugPrint('successs');
      } else {
        print(' ${response.statusCode}');
      }
    } catch (e) {
      print('$e');
    } finally {
      loading.value = false;
    }
  }
}
