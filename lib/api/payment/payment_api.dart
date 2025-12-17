import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/network/http_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThawaniPayController extends GetxController {
  RxString paymentUrl = ''.obs;
  RxString sessionId = ''.obs;
  RxBool isLoading = false.obs;

  //wallet recharge payment initiation
  Future<dynamic> initiatePayment(double amount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final user = await SharedPrefsHelper.getString('username');
      final userId = await SharedPrefsHelper.getInt('userId');

      isLoading.value = true;
      final referenceId = user;
      final payLoad = {
        "client_reference_id": referenceId,
        "mode": 'payment',
        "products": [
          {
            "name": 'Mzadcom Wallet : Recharge',
            "quantity": 1,
            "unit_amount": (amount * 1000).toInt(),
          },
        ],
        "success_url": "https://thw.om/success",
        //?ptype=online&type=wallet_recharge&amt=${amount.toInt()}",
        "cancel_url": "https://thw.om/cancel",
        //  "customer_id": user.thawani_id,
        //is_save_card_allowed: true,
        "metadata": {
          'Customer name': user,
          'Order id': userId.toString(),
          "user": userId.toString(),
        },
      };
      print("amount here is ££££££££££ ${(amount * 1000).toInt()}]}");
      final response = await ApiHelper().postMethod(
        url: "$thawaniBaseUrl/api/v1/checkout/session",
        body: jsonEncode(payLoad),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${pref.getString('token')}',
          "thawani-api-key": thawaniAPIKey,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          paymentUrl.value =
              '${thawaniBaseUrl!}/pay/${data['data']['session_id']}?key=$thawaniPublicKey';
          print(
            '${thawaniBaseUrl!}/pay/${data['data']['session_id']}?key=$thawaniAPIKey',
          );

          return data;
          //'${thawaniBaseUrl!}/pay/${data['data']['session_id']}?key=$thawaniPublicKey';
        }

        return '';
      } else {
        print('Failed to create Thawani session: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error initiating payment: $e');
      return '';
    }
  }
}

// [2:55 pm, 7/10/2025] Adhil PK oman:

//  async gotoPayment(e) {
//     this.setState({ is_payment_loading: true });
//     let recharge_amount = this.state.input.recharge_amount;

//     let { online_type } = this.state;
//     let two_percent = (parseFloat(recharge_amount) * 2) / 100;
//     let credit_amount = parseFloat(recharge_amount) + parseFloat(two_percent);

//     let one_five_percent = (parseFloat(recharge_amount) * 1.5) / 100;
//     let debit_amount = parseFloat(recharge_amount) + parseFloat(one_five_percent);
//     if (online_type === 'local') {
//       recharge_amount = debit_amount;
//     }
//     if (online_type === 'credit') {
//       recharge_amount = credit_amount;
//     }

//     //let customer_id = this.state.thawani_data_id;
//     let queryParams = '?ptype=online&type=wallet_recharge&amt=' + this.state.input.recharge_amount;
//     //let rand_digit = Math.floor(10000 + Math.random() * 90000);
//     let reference_id = user.email;
//     localStorage.setItem('client_reference_id', reference_id);
//     let payload = {
//       client_reference_id: reference_id,
//       mode: 'payment',
//       products: [
//         {
//           name: 'Mzadcom Wallet : Recharge',
//           quantity: 1,
//           unit_amount: parseInt(recharge_amount) * 1000,
//         },
//       ],
//       success_url: walletPaymentSuccessUrl + queryParams,
//       cancel_url: walletPaymentCancelledUrl,
//       customer_id: user.thawani_id,
//       is_save_card_allowed: true,
//       metadata: {
//         'Customer name': user.name,
//         'Order id': user.id + '',
//         user: user.id,
//       },
//     };

//     let thw = await createThawaniSession(payload);
//     if (thw && thw.data && thw.success && thw.data.session_id) {
//       let session_id = thw.data.session_id;
//       localStorage.setItem('thawani_payment_res', JSON.stringify(thw.data));
//       localStorage.setItem('invoice', thw.data.invoice);
//       window.location.href =
//         thawaniPaymentUrl + session_id + '?key=' + thawaniConfig.publishable_key;
//       this.setState({ is_payment_loading: false });
//     } else {
//       this.setState({ is_payment_loading: false });
//     }
//   }
// [2:57 pm, 7/10/2025] Adhil PK oman: 

// async function createThawaniSession(payload) {
//   try {
//     let config = {
//       headers: {
//         "Content-Type": "application/json",
//         "thawani-api-key": thawaniConfig["thawani-api-key"],
//       },
//     };
//     const { data: response } = await axios.post(
//       thawaniUrl + "checkout/session",
//       payload,
//       config
//     );
//     return response;
//   } catch (error) {
//     /**
//      * `Some errors occured. The field UnitAmount must be between 1 and ${
//         5000000 / 1000
//       }`,
//      */
//     swal(
//       "Error",
//       `Some errors occured. The field Amount must be between 1 and ${
//         5000000 / 1000
//       }`,
//       "error"
//     );
//   }
// }