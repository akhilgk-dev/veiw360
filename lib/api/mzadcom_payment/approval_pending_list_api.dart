import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/mzadcom_payment/approval_pending_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApprovalPendingListApi extends GetxController {
  RxBool isLoading = false.obs;

  Future<ApprovalPendingResponse> fetchPaymentDetails() async {
    try {
      isLoading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await ApiHelper().getMethod(
        url: '$baseUrl$approvalPendingListEndpoint',
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        isLoading.value = false;
        return ApprovalPendingResponse(
          success: false,
          message: 'Error: ${response.statusCode}',
          data: [],
        );
      }
      isLoading.value = false;
      return ApprovalPendingResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      isLoading.value = false;
      return ApprovalPendingResponse(
        success: false,
        message: e.toString(),
        data: [],
      );
    }
  }
}
