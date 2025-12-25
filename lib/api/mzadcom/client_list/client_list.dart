import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/mzad_overview/client_list_model.dart';

class ClientList extends GetxController {
  RxBool isLoading = false.obs;
  var clientData = [].obs;
  Future<void> fetchClientList() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await ApiHelper().getMethod(
        url: "$baseUrl$clientsList",
        headers: {'Authorization': 'Bearer ${prefs.getString('token')}'},
      );
      if (response.statusCode != 200) {
        isLoading.value = false;
        clientData.value = [];
      }
      print(jsonDecode(response.body)['data']);
      clientData.value = Organization.fromJsonList(
        jsonDecode(response.body)['data'],
      );
      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
      clientData.value = [];
    }
  }
}
