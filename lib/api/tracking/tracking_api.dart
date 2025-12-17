import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/tracking/tracking_model.dart';

class TrackingApi {
  Future<TrackingModel> getTracking(
    Ref ref, {
    required int auctionId,
    required int groupId,
    required int clientId,
  }) async {
    try {
      final headers = await ApiHelper().headersWithToken();
      final response = await ApiHelper().getMethod(
        url:
            "$baseUrl$trackingEndPoint?auction=$auctionId&group=$groupId&client=$clientId",
        headers: headers,
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

final trackingApiProvider = Provider((ref) => TrackingApi());

final trackingResponseProvider =
    FutureProvider.family<TrackingModel, TrackingParams>((
      ref,
      trackingParams,
    ) async {
      final api = ref.read(trackingApiProvider);
      return api.getTracking(
        ref,
        auctionId: trackingParams.auctionId,
        groupId: trackingParams.groupId,
        clientId: trackingParams.clientId,
      );
    });

class TrackingParams {
  final int auctionId;
  final int groupId;
  final int clientId;
  TrackingParams({
    required this.auctionId,
    required this.groupId,
    required this.clientId,
  });
}
