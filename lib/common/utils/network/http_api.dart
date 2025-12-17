import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:view360/common/utils/helpers/shared_pref.dart';

class InternetStatus extends GetxController {
  var isConnected = false.obs;

  void checkInternetConnection(bool value) {
    isConnected.value = value;
  }
}

var internetlost = false.obs;

class ApiHelper {
  Future<Map<String, String>> headersWithToken() async {
    internetlost.value = false;

    final token = await SharedPrefsHelper.getString('token');
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Map<String, String> headersWithoutToken() {
    internetlost.value = false;

    return {"Content-Type": "application/json"};
  }

  //*-----

  Future<http.Response> getMethod({
    required String url,
    required Map<String, String> headers,
  }) async {
    internetlost.value = false;

    final response = await http.get(Uri.parse(url), headers: headers);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> postMethod({
    required String url,
    required Map<String, String> headers,
    required String body,
  }) async {
    internetlost.value = false;

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    // _handleResponse(response);

    return response;
  }

  void handleNetworkException(Exception e) {
    if (e is SocketException) {
      internetlost.value = true;
      throw Exception(
        "No Internet connection. Please check your network settings and try again.",
      );
    } else if (e is TimeoutException) {
      throw Exception("The connection has timed out. Please try again later.");
    } else {
      throw Exception("An unexpected network error occurred: ${e.toString()}");
    }
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        "Error: ${response.statusCode} - ${response.reasonPhrase}",
      );
    }
  }
}
