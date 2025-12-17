import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/authentication/registration/state/file_upload/file_upload_state.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/bank_transfer_widget_field.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/file_upload_getx_widget.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/terms_condition.dart';
import 'package:view360/view/widgets/diologue_box/diologue_box.dart';
import 'package:view360/view/widgets/image_picker_download/image_picker_all.dart';
import '../../../../common/theme/colors.dart';
import '../../../../common/theme/style.dart';

class BankPaymentOffline extends ConsumerWidget {
  BankPaymentOffline({
    super.key,
    required this.formkey,
    required this.filesUploadGetXController,
    required this.filePickerNotifier,
    required this.checkboxProvider,
    required this.emailVerifiedAt,
    required this.phoneNumberVerifiedAt,
    required this.enrollName,
    required this.auctionID,
    required this.isCompany,
    required this.guaranteeAmount,
  });

  final FilesUploadGetX filesUploadGetXController;
  final PickImageGetX filePickerNotifier;
  final StateProvider<bool> checkboxProvider;
  final String? emailVerifiedAt;
  final String? phoneNumberVerifiedAt;
  final GlobalKey<FormState> formkey;
  final String enrollName;
  final int auctionID;
  final int isCompany;
  final double guaranteeAmount;

  //------------------------------------------------------------------------------
  final TextEditingController civilIdController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAccountNumberController =
      TextEditingController();
  final TextEditingController beneficiaryNameController =
      TextEditingController();

  //----------------------------------------------------------------------------
  final RxList<Map<String, dynamic>> receiptFields =
      <Map<String, dynamic>>[].obs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BankTransferTextField(
            keyBOARD: TextInputType.twitter,
            hinttext: 'Enter your civil ID'.tr,
            controller: civilIdController,
            label: "Civil ID".tr,
            validator: (value) =>
                value!.isEmpty ? 'Please enter an civil ID'.tr : null,
          ),
          BankTransferTextField(
            hinttext: 'Enter your bank name'.tr,
            controller: bankNameController,
            label: "Bank Name".tr,
            validator: (value) =>
                value!.isEmpty ? 'Please enter the bank name'.tr : null,
          ),
          BankTransferTextField(
            keyBOARD: TextInputType.number,
            hinttext: 'Enter your bank account number'.tr,
            controller: bankAccountNumberController,
            label: "Bank Account Number".tr,
            validator: (value) => value!.isEmpty
                ? 'Please enter the bank account number'.tr
                : null,
          ),
          BankTransferTextField(
            hinttext: 'Enter your beneficiary name'.tr,
            controller: beneficiaryNameController,
            label: "Beneficiary name".tr,
            validator: (value) =>
                value!.isEmpty ? 'Please enter the beneficiary name'.tr : null,
          ),

          //* Dynamic receipt fields
          Obx(() {
            return Column(
              children: [
                ...receiptFields.map((field) {
                  final index = receiptFields.indexOf(field);
                  return Column(
                    children: [
                      BankTransferTextField(
                        keyBOARD: TextInputType.text,
                        hinttext: 'Enter your receipt number'.tr,
                        controller: field['controller'],
                        label: "Receipt ${index + 1}".tr,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter the receipt number'.tr
                            : null,
                      ),
                      Obx(() {
                        final filename =
                            "${field['file']?.path.split('/').last ?? 'No file selected'.tr}";
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: FileUploadFielMethod(
                            label: "Upload Receipt ${index + 1}".tr,
                            fileName: filename,
                            ontap: () {
                              filePickerNotifier.pickPdf(field['file']);
                            },
                          ),
                        );
                      }),
                      height10,
                    ],
                  );
                }).toList(),
                IconButton(
                  icon: Icon(Icons.add_circle, color: darkBlue),
                  onPressed: () {
                    receiptFields.add({
                      'controller': TextEditingController(),
                      'file': null,
                    });
                  },
                ),
              ],
            );
          }),

          //* terms and consition----------------------------------------
          TermsAndConditionWidget(
            checkboxProvider: checkboxProvider,
            termsAndCondition: '',
            onChanged: (value) {
              print("Terms accepted: $value");
            },
          ),

          //*submit button------------------------------------------------------
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
                    if (emailVerifiedAt == null ||
                        phoneNumberVerifiedAt == null) {
                      diologueBox();
                      return;
                    }

                    ref.invalidate(
                      auctionAllDetailsResponseProvider(auctionID),
                    );

                    final civilId = civilIdController.text;
                    final bankName = bankNameController.text;
                    final bankAccountNumber = bankAccountNumberController.text;
                    final beneficiaryName = beneficiaryNameController.text;

                    if (formkey.currentState!.validate()) {
                      for (var field in receiptFields) {
                        if (field['file'] == null) {
                          SnackbarHelper.showSnackBar(
                            context,
                            'Please upload all files'.tr,
                            color: darkRed,
                          );
                          return;
                        }
                      }

                      final receiptData = receiptFields.map((field) {
                        return {
                          'receiptNumber': field['controller'].text,
                          'fileReceipt': field['file'].path.toString(),
                        };
                      }).toList();

                      final model = {
                        'auctionId': auctionID,
                        'enrollName': enrollName,
                        'identityType': 'Civilcard'.tr,
                        'civilId': civilId,
                        'bank': bankName,
                        'accountNumber': bankAccountNumber,
                        'beneficiary': beneficiaryName,
                        'isCompany': isCompany,
                        'isOffline': true,
                        'ptype': 'offline'.tr,
                        'amount': guaranteeAmount,
                        'receipts': receiptData,
                      };

                      // print(model);

                      // await bankTransferPaymentController.bankTransfer(
                      //   model,
                      //   null,
                      // );

                      // if (bankTransferPaymentController.success.value == true) {
                      //   Get.back();
                      //   Get.snackbar(
                      //     'Success'.tr,
                      //     'Enrollment successfully done, please wait for the admin approval'
                      //         .tr,
                      //     backgroundColor: Colors.green,
                      //     colorText: Colors.white,
                      //   );
                      // } else {
                      //   Get.snackbar(
                      //     'Error'.tr,
                      //     bankTransferPaymentController.erroMessage.value.tr,
                      //     backgroundColor: darkRed,
                      //     colorText: Colors.white,
                      //   );
                      // }
                    }
                  },
                  child: Obx(
                    () =>
                        // bankTransferPaymentController.isLoading.value
                        //     ? SizedBox(
                        //         height: 20,
                        //         width: 20,
                        //         child: CircularProgressIndicator(
                        //           color: white,
                        //           strokeWidth: 1,
                        //         ),
                        //       )
                        //     :
                        Text("Submit".tr, style: whiteStyle),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
