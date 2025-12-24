import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/mzad_overview/mzad_project_over_model.dart';

class MzadProjectOverview extends GetxController {
  RxBool isloading = false.obs;
  var data = MzadProjectOverModel(projectSummary: null, vatSummary: null).obs;
  Future<void> getProjectOverviewData(String startDate, String endDate) async {
    try {
      isloading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await ApiHelper().getMethod(
        url: '$baseUrl$mzadProjectAndVAT?startDate=$startDate&endDate=$endDate',
        headers: {'Authorization': 'Bearer ${pref.getString('token')}'},
      );
      if (response.statusCode != 200) {
        isloading.value = false;
        data.value = MzadProjectOverModel(
          projectSummary: null,
          vatSummary: null,
        );
      }
      print(jsonDecode(response.body)['data']);
      data.value = MzadProjectOverModel.fromJson(
        jsonDecode(response.body)['data'],
      );
      isloading.value = false;
    } catch (e) {
      isloading.value = false;
      data.value = MzadProjectOverModel(projectSummary: null, vatSummary: null);
    }
  }
}
