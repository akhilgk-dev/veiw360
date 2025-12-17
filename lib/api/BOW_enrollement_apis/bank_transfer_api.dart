import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/enrollment_models/bank_transfer_enrollment/banktransfer_model.dart';

class BankTransferApi extends GetxController {
  final isLoading = false.obs;
  RxBool success = false.obs;
  final erroMessage = ''.obs;

  Future<void> bankTransfer(EnrollBanktransferModel model, File file) async {
    isLoading(true);
    try {
      String? accessToken = await SharedPrefsHelper.getString('token');
      var uri = Uri.parse(baseUrl + enrollBankTransferEndpoint);
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        })
        ..fields['auction'] = model.auctionId.toString()
        ..fields['enroll_name'] = model.enrollName
        ..fields['identity_type'] = model.identityType
        ..fields['civil_id'] = model.civilId
        ..fields['bank'] = model.bank
        ..fields['account_number'] = model.accountNumber
        ..fields['beneficiary'] = model.beneficiary
        ..fields['receipt_number'] = model.receiptNumber
        ..fields['is_company'] = true.toString()
        ..fields['is_offline'] = model.isOffline.toString()
        ..fields['ptype'] = model.ptype
        ..fields['amount'] = model.amount.toString();
      // Add the receipt file
      request.files.add(
        http.MultipartFile(
          'file_receipt',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ),
      );

      // Print the fields and file being sent
      print('Fields being sent: ${request.fields}');
      print('File being sent: ${file.path}');

      var response = await request.send();

      if (response.statusCode == 200) {
        print(response.statusCode);
        final responseBody = await response.stream.bytesToString();
        print(responseBody);
        success.value = jsonDecode(responseBody)['success'];
        erroMessage.value = jsonDecode(responseBody)['message'] ?? '';
      } else {
        // Read the response body
        final responseBody = await response.stream.bytesToString();

        // Decode the response body to get the actual content
        final decodedResponse = jsonDecode(responseBody);

        print(decodedResponse);
        debugPrint('Error in bank transfer: ${response.statusCode}');
        debugPrint('Response body: $decodedResponse');
      }
    } on Exception catch (e) {
      debugPrint('Error in bank transfer: $e');
      ApiHelper().handleNetworkException(e);
    } finally {
      isLoading(false);
    }
  }
}
