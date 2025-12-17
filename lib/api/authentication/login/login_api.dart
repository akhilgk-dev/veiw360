import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/network/http_api.dart';

import '../../../model/authentication/login/login_model.dart';

class LoginApi extends GetxController {
  RxBool success = false.obs;
  RxString message = ''.obs;
  RxString token = ''.obs;
  final isLoading = false.obs;

  //-------------------Login-------------------
  Future<void> login(LoginModel model) async {
    success.value = false;
    isLoading.value = true;
    final response = await ApiHelper().postMethod(
      headers: ApiHelper().headersWithoutToken(),
      url: baseUrl + loginEndpoint,
      body: jsonEncode(model.toJson()),
    );

    // print(model.toJson());

    try {
      if (response.statusCode == 200) {
        debugPrint(response.body);
        final data = await jsonDecode(response.body)['data'];
        success.value = await jsonDecode(response.body)['success'];
        SharedPrefsHelper.saveString('token', data['token']);
        SharedPrefsHelper.saveInt('userId', data['user']['id']);
      } else {
        debugPrint(response.body);
        message.value = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint("$e");
    } finally {
      isLoading.value = false;
    }
  }

  void logOut() {
    SharedPrefsHelper.remove('token');
    SharedPrefsHelper.remove('userId');
    success.value = false;
  }
}
