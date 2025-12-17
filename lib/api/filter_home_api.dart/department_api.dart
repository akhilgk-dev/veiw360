import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/filter_model_in_home/departments/police_station_model.dart';

final messageProviderdepartment = StateProvider<String>((ref) => '');

class DepartmentApi {
  Future<PoliceStationResponse> getdepartmentList(Ref ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // API call to get department list
      final response = await ApiHelper().getMethod(
        url: baseUrl + departmentListEndPoint,
        headers: {'Authorization': 'Bearer ${pref.getString('token')!}'},
      );

      if (response.statusCode == 200) {
        return PoliceStationResponse.fromJson(json.decode(response.body));
      } else {
        debugPrint(response.statusCode.toString());
        ref.read(messageProviderdepartment.notifier).state = json.decode(
          response.body,
        )['message'];
        return Future.error('Failed to load active auctions');
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint('$e');

      ref.read(messageProviderdepartment.notifier).state =
          'An error occurred: $e';
      return Future.error('Failed to load active auctions');
    }
  }
}

final departmentModelProvider = Provider((ref) => DepartmentApi());

final auctionResponsedepartment = FutureProvider<PoliceStationResponse>((
  ref,
) async {
  final departmentService = ref.read(departmentModelProvider);
  return departmentService.getdepartmentList(ref);
});
