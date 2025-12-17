import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/authentication/registration/institution_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstitutionRegistrationController extends GetxController {
  final isLoading = false.obs;
  final success = false.obs;
  final erroMessage = ''.obs;
  final token = ''.obs;

  /// HTTP POST method for client registration
  Future<bool> registerClientInstitution(
    InstitutionRegisterModel registration,
  ) async {
    isLoading(true);
    try {
      final response = await ApiHelper().postMethod(
        url: baseUrl + endpointInstitution,
        headers: ApiHelper().headersWithoutToken(),
        body: jsonEncode(registration.toJson()),
      );

      // print(
      //     "EncodeApi=========================${jsonEncode(registration.toJson())}");

      if (response.statusCode == 200) {
        print("Response=========================${response.body}");
        success.value = await jsonDecode(response.body)['success'];
        if (success.value == true) {
          SharedPrefsHelper.saveString(
            'token',
            await jsonDecode(response.body)['data']['token'],
          );
          token.value = await jsonDecode(response.body)['data']['token'];
        } else {
          print(response.body);
          debugPrint('Error registering client: ${response.statusCode}');
          erroMessage.value = response.body;
        }
        return true;
      } else {
        debugPrint(response.body);
        debugPrint('Error registering client: ${response.statusCode}');
        return false;
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint('Error registering client: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}

//edit institution registration-------------------------------------------------

class EditInstitutionApi extends GetxController {
  final isLoading = false.obs;
  final success = false.obs;
  final erroMessage = ''.obs;
  final token = ''.obs;

  /// HTTP POST method for client registration
  Future<bool> editProfileInstitution(
    InstitutionRegisterModel registration,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isLoading(true);
    try {
      final response = await ApiHelper().postMethod(
        url: baseUrl + profileEndpoint,
        headers: {
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(registration.toJson()),
      );

      print(
        "EncodeApi=========================${jsonEncode(registration.toJson())}",
      );

      if (response.statusCode == 200) {
        print("Response=========================${response.body}");
        success.value = await jsonDecode(response.body)['success'];
        if (success.value == true) {
          print('success====true');
          token.value = await jsonDecode(response.body)['data']['token'];
        } else {
          erroMessage.value = await jsonDecode(response.body)['message'];
        }
        return true;
      } else {
        debugPrint(response.body);
        debugPrint('Error registering client: ${response.statusCode}');
        return false;
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint('Error registering client: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
