import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/api_url/api_helper.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/add_fund_to_wallet/bank_way_model.dart';
import 'package:view360/view/enrollment_payment_screen/payment_system/online_system/online_paymant_system.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/theme/colors.dart';
import '../../../../common/theme/sized_box.dart';
import '../../../../common/theme/style.dart';
import '../../../authentication/registration/state/file_upload/file_upload_state.dart';
import '../../../widgets/image_picker_download/image_picker_all.dart';
import '../../widgets/bank_details_guarntee_amount_policy.dart';
import '../../widgets/bank_transfer_widget_field.dart';
import '../../widgets/file_upload_getx_widget.dart';
import '../../widgets/selectable_payement_method_card.dart';
import 'package:http/http.dart' as http;

final selectedAddfundwallet = StateProvider<String>((ref) => 'Online');

class AddFundScreen extends ConsumerWidget {
  final String addFund;
  final String enrollName;
  final int auctionID;
  final int isCompany;
  final String civilID;
  final String bankName;
  final String accountNumber;
  final String beneficiary;
  final String? emailVerifiedAt;
  final String? phoneNumberVerifiedAt;

  AddFundScreen({
    super.key,
    required this.addFund,
    required this.civilID,
    required this.bankName,
    required this.accountNumber,
    required this.beneficiary,
    required this.enrollName,
    required this.auctionID,
    required this.isCompany,
    required this.emailVerifiedAt,
    required this.phoneNumberVerifiedAt,
  });
  final checkboxProvider = StateProvider<bool>((ref) => false);
  final AddFundUsingBanktransfer addFundUsingBanktransfer = Get.put(
    AddFundUsingBanktransfer(),
  );
  final FilesUploadGetX filesUploadGetX = Get.put(FilesUploadGetX());
  final PickImageGetX filePickerNotifier = Get.put(PickImageGetX());
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(selectedAddfundwallet);
    final TextEditingController amount = TextEditingController();
    final TextEditingController bankNameController = TextEditingController();
    final TextEditingController bankAccountNumberController =
        TextEditingController();
    final TextEditingController receiptController = TextEditingController();

    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppbarWidget(title: 'Add Fund'.tr),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectablePaymentMethodWidget(
                addfund: addFund,
                ref: ref,
                selectedPaymentMethod: selectedPaymentMethod,
              ),
              height10,

              Row(
                children: [
                  //* guarantee amount static ----------------------------------
                  GuranteeAmountStatic(),
                  width10,
                  //* Bank details ---------------------------------------------
                  BankDetailsStaticContainer(),
                ],
              ),
              height10,
              selectedPaymentMethod == 'Bank'
                  ? Form(
                      key: formkey,
                      child: Column(
                        children: [
                          BankTransferTextField(
                            keyBOARD: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            hinttext: 'Enter amount to add'.tr,
                            controller: amount,
                            label: "Amount".tr,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter the amount to add fund'.tr
                                : null,
                          ),
                          height10,
                          BankTransferTextField(
                            hinttext: 'Enter your bank name'.tr,
                            controller: bankNameController,
                            label: "Bank Name".tr,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter the bank name'.tr
                                : null,
                          ),
                          BankTransferTextField(
                            hinttext: 'Enter your bank account number'.tr,
                            controller: bankAccountNumberController,
                            label: "Bank Account Number".tr,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter the bank account number'.tr
                                : null,
                          ),
                          BankTransferTextField(
                            hinttext: 'Enter your beneficiary name'.tr,
                            controller: receiptController,
                            label: "Receipt".tr,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter the receipt number'.tr
                                : null,
                          ),
                          Obx(() {
                            final filename =
                                '${filesUploadGetX.uploadRecieptforWalletAddFund.value?.path.split('/').last}';
                            return FileUploadFielMethod(
                              label: "Upload Receipt".tr,
                              fileName: filename == 'null'
                                  ? 'No file selected'.tr
                                  : filename,
                              ontap: () {
                                filePickerNotifier.pickPdf(
                                  filesUploadGetX.uploadRecieptforWalletAddFund,
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    )
                  : OnlinePaymentSystem(
                      termsAndCondition: '',
                      page: 'walletPage',
                      enrollEmail: enrollName,
                      emailVerifiedAt: emailVerifiedAt,
                      phoneNumberVerifiedAt: phoneNumberVerifiedAt,
                      guaranteeAmount: 0.0,
                      checkboxProvider: checkboxProvider,
                      enrollName: enrollName,
                      auctionID: auctionID,
                      isCompany: isCompany,
                      civilID: civilID,
                      bankName: bankName,
                      accountNumber: accountNumber,
                      beneficiary: beneficiary,
                    ),

              //checking if the selected payment method is bank , and online method already there is button in the widget class
              if (selectedPaymentMethod == 'Bank')
                //* pay now button ---------------------------------------------
                Column(
                  children: [
                    height20,
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(darkBlue),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              ref.invalidate(
                                auctionAllDetailsResponseProvider(auctionID),
                              );
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              final userid = pref.getInt('userId') ?? 0;
                              if (formkey.currentState!.validate()) {
                                final model = BankWayModel(
                                  fileReceipt: filesUploadGetX
                                      .uploadRecieptforWalletAddFund
                                      .toString(),
                                  credit: amount.text.isEmpty
                                      ? 0
                                      : int.parse(amount.text),
                                  accountNumber: int.parse(
                                    bankAccountNumberController.text,
                                  ),
                                  bank: bankNameController.text,
                                  receiptNumber: receiptController.text,
                                  method: 'offline',
                                  status: 'P',
                                  type: 'wallet_recharge',
                                  user: userid,
                                );

                                print(model.toJson());

                                final receiptFile = filesUploadGetX
                                    .uploadRecieptforWalletAddFund
                                    .value;
                                if (receiptFile == null) {
                                  if (context.mounted) {
                                    SnackbarHelper.showSnackBar(
                                      context,
                                      'Please upload a receipt file',
                                    );
                                  }
                                  return;
                                }
                                final result = await addFundUsingBanktransfer
                                    .addFundWalletUsingBank(model, receiptFile);

                                if (result) {
                                  if (context.mounted) {
                                    SnackbarHelper.showSnackBar(
                                      context,
                                      'Fund added successfully',
                                    );
                                  }
                                  Get.back();
                                } else {
                                  if (context.mounted) {
                                    SnackbarHelper.showSnackBar(
                                      context,
                                      'Failed to add fund',
                                    );
                                  }
                                }
                              }
                            },
                            child: Text("Pay now".tr, style: whiteStyle),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddFundUsingBanktransfer extends GetxController {
  final isLoading = false.obs;
  RxBool success = false.obs;
  final errorMessage = ''.obs;

  Future<bool> addFundWalletUsingBank(BankWayModel model, File file) async {
    isLoading(true);
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? accessToken = pref.getString('token');

      var uri = Uri.parse('$baseUrl/wallet_transaction');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({'Authorization': 'Bearer $accessToken'})
        ..fields['credit'] = model.credit.toString()
        ..fields['account_number'] = model.accountNumber.toString()
        ..fields['bank'] = model.bank
        ..fields['receipt_number'] = model.receiptNumber
        ..fields['method'] = model.method
        ..fields['status'] = model.status
        ..fields['type'] = model.type
        ..fields['user'] = model.user.toString();

      // Attach file
      request.files.add(
        http.MultipartFile(
          'file_receipt',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ),
      );

      // Debug info
      print('Sending Fields: ${request.fields}');
      print('Sending File: ${file.path}');

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decoded = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        print('Add fund successful: $decoded');
        success.value = decoded['success'] ?? true;
        errorMessage.value = decoded['message'] ?? '';
        return true;
      } else {
        print('Failed to add fund: $decoded');
        success.value = false;
        errorMessage.value = decoded['message'] ?? 'Something went wrong';
        return false;
      }
    } catch (e) {
      debugPrint('Exception in addFundWalletUsingBank: $e');
      //ApiHelper().handleNetworkException("$e");
      return false;
    } finally {
      isLoading(false);
    }
  }
}

// class AddFundUsingBanktransfer extends GetxController {
//   var loading = false.obs;

//   Future<bool> addFundWalletUsingBank(BankWayModel model) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     final response = await ApiHelper().postMethod(
//       url: '$baseUrl/wallet_transaction',
//       headers: {
//         'Authorization': 'Bearer ${pref.getString('token')}',
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode(model.toJson()),
//     );
//     debugPrint('${model.toJson()}');
//     if (response.statusCode == 200) {
//       print('success');
//       return true;
//     } else {
//       print(response.statusCode);
//       print(response.body);
//       return false;
//     }
//   }
// }
