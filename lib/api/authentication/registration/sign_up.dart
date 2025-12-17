import 'dart:convert';

import 'package:get/get.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  final isLoading = false.obs;
  RxBool success = false.obs;
  final errorMessage = ''.obs;
  final token = ''.obs;

  //previous it was individual and institutional
  Future<void> signUpCommon(SignUpHeaders headers) async {
    isLoading.value = true;
    try {
      final url = baseUrl + signUpCommonEndPoint;
      final response = await http.post(Uri.parse(url), body: headers.toJson());
      if (response.statusCode == 200) {
        final responseBody = response.body;
        token.value = jsonDecode(responseBody)['data']['token'];
        SharedPrefsHelper.saveString('token', token.value);
        SharedPrefsHelper.saveInt(
          'userId',
          jsonDecode(responseBody)['data']['user']['id'],
        );
        SharedPrefsHelper.saveBool('isVarified', false);

        //saving username and password for fingerprint
        SharedPrefsHelper.saveString('username', headers.username);
        SharedPrefsHelper.saveString('password', headers.password);
        success.value = jsonDecode(responseBody)['success'];
        isLoading.value = false;
      } else {
        errorMessage.value = 'Error: ${jsonDecode(response.body)['errors'][0]}';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}

class SignUpHeaders {
  final String name;
  final String username;
  final String email;
  final String countryCode;
  final String mobile;
  final String password;
  final String passwordConfirmation;

  SignUpHeaders({
    required this.name,
    required this.username,
    required this.email,
    required this.countryCode,
    required this.mobile,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'country_code': countryCode,
      'mobile': mobile,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
