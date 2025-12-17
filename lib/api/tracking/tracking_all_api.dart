import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/tracking/tracking_model.dart';

class TrackingAllApi {
  Future<TrackingModel> getAllTracking() async {
    try {
      final response = await ApiHelper().getMethod(
        url: '$baseUrl$trackingEndPoint',
        headers: await ApiHelper().headersWithToken(),
      );

      if (response.statusCode == 200) {
        return TrackingModel.fromJson(json.decode(response.body));
      } else {
        return Future.error(
          'Failed to load tracking data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      return Future.error('Failed to load tracking data: $e');
    }
  }
}

final trackingAllApiProvider = Provider((ref) => TrackingAllApi());
final trackingAllResponseProvider = FutureProvider<TrackingModel>((ref) async {
  final api = ref.read(trackingAllApiProvider);
  return api.getAllTracking();
});
