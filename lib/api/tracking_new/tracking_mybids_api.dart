import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/new_tracking/new_tracking.dart';

class TrackingMybidsApi {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool success = false.obs;
  Tracking? trackingData;
  dynamic responseData;

  Future<void> getTrackingMyBids({required int auctionId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      success.value = false;
      final response = await ApiHelper().getMethod(
        url: baseUrl + auctionTracking + auctionId.toString(),
        headers: await ApiHelper().headersWithToken(),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print(
          'API Response: $responseBody',
        ); // Debug log to inspect the response
        try {
          responseData = json.decode(response.body);
          trackingData = Tracking.fromJson(responseBody['data']);
          print(
            'Parsed Tracking Data: $trackingData',
          ); // Debug log to inspect the parsed data
          success.value = true;
        } catch (e) {
          print(
            'Error parsing Tracking data: $e',
          ); // Debug log for parsing errors
          errorMessage.value = 'Error parsing Tracking data: $e';
        }
        isLoading.value = false;
      } else {
        trackingData = null;
        isLoading.value = false;
        success.value = false;
        errorMessage.value =
            'Failed to load tracking data: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('error in tracking my bids: $e');
      isLoading.value = false;
      success.value = false;
      errorMessage.value = 'Failed to load tracking data: $e';
    }
  }
}
