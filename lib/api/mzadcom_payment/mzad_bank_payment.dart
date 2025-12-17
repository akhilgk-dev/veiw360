import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/view/mzadcom_payment/payment_bottom_sheet.dart';

class MzadBankPayment {
  RxBool isLoading = false.obs;
  RxBool success = false.obs;

  Future<void> bankPayment(
    double totalAmount,
    List<SelectedAuction> selectedAuctionPayments,
    String bankName,
    String bankAccountNumber,
    List<Map<String, dynamic>> receiptFields,
  ) async {
    try {
      isLoading(true);
      String? accessToken = await SharedPrefsHelper.getString('token');
      var uri = Uri.parse(baseUrl + mzadWalletPayment);
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({'Authorization': 'Bearer $accessToken'});

      //
      request.fields['paymentMethod'] = 'offline';
      request.fields['subtotal'] = totalAmount.toString();
      for (int i = 0; i < selectedAuctionPayments.length; i++) {
        request.fields['auctions[$i][id]'] = selectedAuctionPayments[i]
            .auction
            .id
            .toString();
        request.fields['auctions[$i][amount]'] = selectedAuctionPayments[i]
            .amount
            .toString();
      }

      request.fields['bankName'] = bankName;
      //request.fields['accountNumber'] = bankAccountNumber;
      // request.fields['receiptNumber'] = receiptFields[0]['textController'].text;
      request.fields['paymentsCount'] = receiptFields.length.toString();

      for (int i = 0; i < receiptFields.length; i++) {
        var file = receiptFields[i]['fileController'].value;
        var receiptNumber = receiptFields[i]['textController'].text;
        var amount = receiptFields[i]['amountController'].text;
        request.fields['payments[$i][receiptNumber]'] = receiptNumber;
        request.fields['payments[$i][amount]'] = amount;
        if (file != null) {
          request.files.add(
            http.MultipartFile(
              'payments[$i][receiptImage]',
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: file.path.split('/').last,
            ),
          );
        }
      }

      print(uri);
      print(request.fields);
      print(request.files.length);
      request.send().then((response) async {
        if (response.statusCode == 200) {
          print('Bank payment successful');
          success.value = true;
          isLoading.value = false;
        } else {
          isLoading.value = false;
          success.value = false;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
