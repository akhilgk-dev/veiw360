import 'package:get/get_rx/get_rx.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/view/mzadcom_payment/payment_bottom_sheet.dart';
import 'package:http/http.dart' as http;

class MzadWalletPayment {
  RxBool isLoading = false.obs;
  RxBool success = false.obs;

  Future<void> walletPayment(
    double totalAmount,
    List<SelectedAuction> selectedAuctionPayments,
  ) async {
    try {
      isLoading(true);
      String? accessToken = await SharedPrefsHelper.getString('token');
      var uri = Uri.parse(baseUrl + mzadWalletPayment);
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        });
      for (int i = 0; i < selectedAuctionPayments.length; i++) {
        request.fields['auctions[$i][id]'] = selectedAuctionPayments[i]
            .auction
            .id
            .toString();
        request.fields['auctions[$i][amount]'] = selectedAuctionPayments[i]
            .amount
            .toString();
      }

      request.fields['subtotal'] = totalAmount.toString();
      request.fields['paymentMethod'] = 'wallet';
      // Print the data being sent
      print('Sending data:');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });
      print(uri);
      request.send().then((response) {
        if (response.statusCode == 200) {
          print('Wallet payment successful');
          success.value = true;
          isLoading.value = false;
        } else {
          print('Wallet payment failed with status: ${response.statusCode}');
          isLoading.value = false;
          success.value = false;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
