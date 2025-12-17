import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:view360/api/add_fund_to_wallet_online/add_fund_wallet_online.dart';
import 'package:view360/api/payment/payment_api.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:view360/model/enrollment_models/online_payment_enrollment/online_payment_model.dart';
import 'package:view360/view/payment/thawani_webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

//enroll user api for online payment
class PaymentController extends GetxController {
  var enrollId = ''.obs;
  var auctionId = ''.obs;
  var userId = ''.obs;
  var groupId = ''.obs;
  var isLoading = false.obs;
  RxBool successPaymentStatus = false.obs;

  Future<void> enrollUser(
    BuildContext context,
    PaymentHeaderModel paymentHeader,
    OnlinePaymentModel model, {
    required String userName,
    required String userMail,
    required double auctionAmounttoPay,
    required type,
  }) async {
    isLoading(true);
    SharedPreferences pref = await SharedPreferences.getInstance();

    print("Enrolling user with model: ${model.toJson()}");
    print(userName);
    print(userMail);
    print(auctionAmounttoPay);
    print(paymentHeader.groupId);

    try {
      var uri = Uri.parse(baseUrl + enrollBankTransferEndpoint);
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer ${pref.getString('token')}',
          'Content-Type': 'application/json',
        })
        ..fields.addAll(
          model.toJson().map((key, value) => MapEntry(key, value.toString())),
        );

      // final response = await ApiHelper().postMethod(
      //   url: baseUrl + enrollBankTransferEndpoint,
      //   headers: {
      //     'Authorization': 'Bearer ${pref.getString('token')}',
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(model.toJson()),
      // );
      request.send().then((response) async {
        if (response.statusCode == 200) {
          final responseInString = await response.stream.bytesToString();
          final responseData = jsonDecode(responseInString);
          print('Enrollment response data: $responseData');
          if (responseData['success'] == true) {
            enrollId.value = responseData['data']['id'].toString();
            auctionId.value = responseData['data']['aution'].toString();
            userId.value = responseData['data']['user_id'].toString();
            groupId.value = responseData['data']['group_id'].toString();

            // Open payment gateway
            openPaymentGateway(
              userName,
              userMail,
              auctionAmounttoPay,
              type,
              paymentHeader,
              enrollId.value,
            );
          } else {
            SnackbarHelper.showSnackBar(
              context,
              responseData['message'],
              color: darkRed,
            );
            //Get.snackbar('Error', responseData['message']);
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to enroll user: ${response.statusCode}',
          );
        }
      });
      print(jsonEncode(model.toJson()));
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  //----------------------------------------------------------------------------

  void openPaymentGateway(
    String userName,
    String userEmail,
    double auctionAmounttoPay,
    String type,
    PaymentHeaderModel paymentHeader,
    String localEnrollId,
  ) async {
    isLoading(true);
    final ThawaniPayController payment = Get.put(ThawaniPayController());

    final localAmountInCents = auctionAmounttoPay;

    //print(formData);

    // Navigate to WebView
    await payment.initiatePayment(localAmountInCents).then((value) {
      if (value.isNotEmpty) {
        Get.to(
          ThawaniWebview(
            paymentUrl:
                '${thawaniBaseUrl!}/pay/${value['data']['session_id']}?key=$thawaniPublicKey',
            onPaymentSuccess: () {
              successPayment(
                PaymentHeaderModel(
                  groupId: paymentHeader.groupId,
                  auctionId: paymentHeader.auctionId,
                  enrollId: localEnrollId,
                  gatePass: '',
                  amount: paymentHeader.amount,
                  invoice: value['data']['invoice'] ?? '',
                  reference: '',
                  type: paymentHeader.type,
                  isWalletRecharge: false,
                  ptype: 'online',
                ),
              );
            },
          ),
        );
      }
      {
        isLoading(false);
      }
    });
    isLoading(false);
    // Get.to(() => PaymentGatewayScreen(formData: formData));
  }

  void successPayment(PaymentHeaderModel paymentHeader) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${pref.getString('token')}', // Replace with actual token logic
      };

      final body = jsonEncode({
        'group_id': paymentHeader.groupId,
        'auction_id': paymentHeader.auctionId,
        'enroll_id': paymentHeader.enrollId,
        'gatePass': paymentHeader.gatePass,
        'amount': paymentHeader.amount,
        'invoice': paymentHeader.invoice,
        'reference': paymentHeader.reference,
        'type': paymentHeader.type,
        'is_wallet_recharge': paymentHeader.isWalletRecharge,
        'ptype': paymentHeader.ptype,
      });

      final response = await ApiHelper().postMethod(
        url: baseUrl + updatePaymentStatusEndpoint,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('Payment status updated successfully: $responseData');
        isLoading.value = false;
        successPaymentStatus.value = true;
      } else {
        debugPrint('Failed to update payment status: ${response.statusCode}');
      }

      // Handle response if needed
    } catch (e) {
      debugPrint("Error in successPayment: $e");
    }
  }
}
