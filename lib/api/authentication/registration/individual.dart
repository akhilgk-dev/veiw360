import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/authentication/registration/individual_register_model.dart';
import 'package:http/http.dart' as http;

class IndividualRegistrationController extends GetxController {
  final isLoading = false.obs;
  RxBool success = false.obs;
  final erroMessage = ''.obs;
  final token = ''.obs;

  /// HTTP POST method for client registration with file upload
  Future<bool> registerClientIndividual(
    IndividualRegisterModel model,
    File file,
  ) async {
    isLoading(true);
    try {
      // Prepare the request
      var uri = Uri.parse(baseUrl + endpointIndividual);
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(ApiHelper().headersWithoutToken())
        ..fields['name'] = model.name
        ..fields['country_code'] = model.countryCode
        ..fields['mobile'] = model.mobile
        ..fields['email'] = model.email
        ..fields['username'] = model.username
        ..fields['password'] = model.password
        ..fields['confirm_password'] = model.confirmPassword
        ..fields['resident_card_number'] = model.residentCardNumber
        ..fields['account_number'] = model.accountNumber
        ..fields['bank'] = model.bank
        ..fields['is_company'] = model.isCompany.toString();

      // Add the file as a separate part
      request.files.add(
        await http.MultipartFile.fromPath('file_id_number', file.path),
      ); // Use 'file_id_number' for file upload

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response=========================$responseBody');
        success.value = jsonDecode(responseBody)['success'];

        if (success.value == true) {
          SharedPrefsHelper.saveString(
            'access_token',
            jsonDecode(responseBody)['data']['token'],
          );
          token.value = jsonDecode(responseBody)['data']['token'];
        } else {
          debugPrint(responseBody);
          erroMessage.value = jsonDecode(responseBody)['message'];
        }

        return true;
      } else {
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

  //for edit profile
}

//---edit profile--------------------------------------------------

class EditProfile extends GetxController {
  final isLoading = false.obs;
  RxBool success = false.obs;
  final erroMessage = ''.obs;
  final token = ''.obs;

  /// HTTP POST method for client registration with file upload
  Future<bool> editProfile(IndividualRegisterModel model, File file) async {
    isLoading(true);
    try {
      // Retrieve token from SharedPreferences
      String? accessToken = await SharedPrefsHelper.getString('token');

      // Prepare the request
      var uri = Uri.parse(baseUrl + profileEndpoint);
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken', // Add token to headers
          'Content-Type': 'multipart/form-data',
        })
        ..fields['name'] = model.name
        ..fields['country_code'] = model.countryCode
        ..fields['mobile'] = model.mobile
        ..fields['email'] = model.email
        ..fields['username'] = model.username
        ..fields['password'] = model.password
        ..fields['confirm_password'] = model.confirmPassword
        ..fields['resident_card_number'] = model.residentCardNumber
        ..fields['account_number'] = model.accountNumber
        ..fields['bank'] = model.bank
        ..fields['is_company'] = model.isCompany.toString();

      // Add the file as a separate part
      request.files.add(
        await http.MultipartFile.fromPath('file_id_number', file.path),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream
            .bytesToString(); // ✅ Await the response
        debugPrint(
          'Response=========================$responseBody',
        ); // ✅ Print actual string

        success.value = jsonDecode(responseBody)['success'];

        if (success.value) {
          SharedPrefsHelper.saveString(
            'access_token',
            jsonDecode(responseBody)['data']['token'],
          );
          token.value = jsonDecode(responseBody)['data']['token'];
        } else {
          print(responseBody);
          erroMessage.value =
              'Please check with Email & password that is already use or not';
        }

        return true;
      } else {
        erroMessage.value =
            'Please check with Email & password that is already use or not';

        // debugPrint('Error editing profile: $errorMessage');
        return false;
      }
    } on Exception catch (e) {
      ApiHelper().handleNetworkException(e);
      debugPrint('Error editing profile: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
