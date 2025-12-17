// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../common/api_url/api_helper.dart';
// import '../../../../common/utils/network/http_api.dart';

// class PaymentSuccessScreen extends ConsumerStatefulWidget {
//   final String reference;
//   final Map<String, String> formData;

//   const PaymentSuccessScreen(
//       {super.key, required this.reference, required this.formData});

//   @override
//   ConsumerState<PaymentSuccessScreen> createState() =>
//       _PaymentSuccessScreenState();
// }

// class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen> {
//   final onlinePaymentSuccessUpdate = Get.put(OnlinePaymentSuccessUpdate());

//   @override
//   initState() {
//     onlinePaymentSuccessUpdate.updatePaymentStatus(
//       reference: widget.reference,
//       formData: widget.formData,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Success'),
//       ),
//     );
//   }
// }

// class OnlinePaymentSuccessUpdate extends GetxController {
//   var loading = false.obs;
//   Future<void> updatePaymentStatus({
//     required String reference,
//     required Map<String, String> formData,
//   }) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     loading(true);
//     try {
//       final response = await ApiHelper().postMethod(
//         url: baseUrl + updatePaymentStatusEndpoint,
//         headers: {
//           'Authorization': 'Bearer ${pref.getString('token')}',
//           'Content-Type': 'application/json'
//         },
//         body: jsonEncode({
//           'reference': reference,
//           'user_id': formData['udf1'],
//           'type': formData['udf2'],
//           'group_id': formData['udf3'],
//           'enroll_id': formData['udf4'],
//           'auction_id': formData['udf5'],
//           'gate_pass_id': '',
//           'amount': formData['amount'],
//         }),
//       );
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//       } else {
//         print('Failed to update payment status: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Error'.tr, 'An error occurred: $e');
//     } finally {
//       loading(false);
//     }
//   }
// }
