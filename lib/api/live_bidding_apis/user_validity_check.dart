import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserValidityCheckApi extends GetxController {
  var message = ''.obs;
  var enrollstatus = ''.obs;
  var valid = false.obs;
  var loading = false.obs;

  Future<void> checkUserValidity(int auctionID) async {
    loading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();

    final response = await ApiHelper().postMethod(
      url: baseUrl + userValidityCheckEndpoint,
      headers: {
        "Authorization": "Bearer ${pref.getString("token")}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"auction": auctionID}),
    );

    if (response.statusCode == 200) {
      message.value = jsonDecode(response.body)["message"];
      enrollstatus.value = jsonDecode(response.body)['data']["enroll_status"];
      valid.value = jsonDecode(response.body)['data']["valid"];
    } else {
      loading.value = false;
      message.value = jsonDecode(response.body)["message"];
    }
    loading.value = false;
  }
}
