import 'package:view360/model/vehicle_info_model/vehicle_model_info.dart';
import 'dart:convert';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleInfoApi {
  Future<VehicleInfoModel> getVehicleInfo(
    Ref ref, {
    required int auctionId,
  }) async {
    print(auctionId);
    try {
      // API call to get Previous auctions
      final response = await ApiHelper().getMethod(
        url: '$baseUrl/auctions/$auctionId',
        headers: ApiHelper().headersWithoutToken(),
      );
      if (response.statusCode == 200) {
        print(response.body);
        return VehicleInfoModel.fromJson(
          json.decode(response.body)['data']['vehicle_info'],
        );
      } else {
        print(response.body);
        return Future.error('Failed to load active auctions');
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    } finally {}
  }
}

final vehicleauctionProvider = Provider((ref) => VehicleInfoApi());

final auctionResponseProviderVehicle = FutureProvider.family<dynamic, int>((
  ref,
  auctionId,
) async {
  final auctionService = ref.read(vehicleauctionProvider);
  return auctionService.getVehicleInfo(ref, auctionId: auctionId);
});

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
