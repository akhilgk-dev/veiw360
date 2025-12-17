import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/auction_details_api/auction_details_all_api.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/authentication/registration/state/file_upload/file_upload_state.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/bank_transfer_widget_field.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/terms_condition.dart';
import 'package:view360/view/widgets/image_picker_download/image_picker_all.dart';
import '../../../../api/BOW_enrollement_apis/bank_transfer_api.dart';
import '../../../../common/theme/colors.dart';
import '../../../../common/theme/style.dart';
import '../../../../model/enrollment_models/bank_transfer_enrollment/banktransfer_model.dart';
import '../../../widgets/diologue_box/diologue_box.dart';
import '../../widgets/file_upload_getx_widget.dart';

class BankPayment extends ConsumerWidget {
  BankPayment({
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
  final TextEditingController receiptController = TextEditingController();

  //----------------------------------------------------------------------------
  final BankTransferApi bankTransferPaymentController = Get.put(
    BankTransferApi(),
  );
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
          BankTransferTextField(
            keyBOARD: TextInputType.text,
            hinttext: 'Enter your receipt number'.tr,
            controller: receiptController,
            label: "Receipt".tr,
            validator: (value) =>
                value!.isEmpty ? 'Please enter the receipt number'.tr : null,
          ),
          Obx(() {
            final filename =
                "${filesUploadGetXController.uploadRecieptforBankTransfer.value?.path.split('/').last}";
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: FileUploadFielMethod(
                label: "Upload Receipt".tr,
                fileName: filename == 'null' ? 'No file selected'.tr : filename,
                ontap: () {
                  filePickerNotifier.pickPdf(
                    filesUploadGetXController.uploadRecieptforBankTransfer,
                  );
                },
              ),
            );
          }),

          height10,

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
                    final receipt = receiptController.text;
                    final fileReceipt = filesUploadGetXController
                        .uploadRecieptforBankTransfer
                        .value;
                    final isCompany = 0;

                    if (formkey.currentState!.validate()) {
                      if (fileReceipt == null) {
                        SnackbarHelper.showSnackBar(
                          context,
                          'Please upload file'.tr,
                          color: darkRed,
                        );
                        return;
                      }

                      final model = EnrollBanktransferModel(
                        auctionId: auctionID,
                        enrollName: enrollName,
                        identityType: 'Civilcard'.tr,
                        civilId: civilId,
                        bank: bankName,
                        accountNumber: bankAccountNumber,
                        beneficiary: beneficiaryName,
                        receiptNumber: receipt,
                        isCompany: isCompany,
                        isOffline: true,
                        ptype: 'offline'.tr,
                        amount: guaranteeAmount,
                        fileReceipt: fileReceipt.path.toString(),
                      );

                      // print(model.toJson());

                      await bankTransferPaymentController.bankTransfer(
                        model,
                        fileReceipt,
                      );

                      if (bankTransferPaymentController.success.value == true) {
                        Get.back();
                        Get.snackbar(
                          'Success'.tr,
                          'Enrollment successfully done, please wait for the admin approval'
                              .tr,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          'Error'.tr,
                          bankTransferPaymentController.erroMessage.value.tr,
                          backgroundColor: darkRed,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  child: Obx(
                    () => bankTransferPaymentController.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: white,
                              strokeWidth: 1,
                            ),
                          )
                        : Text("Submit".tr, style: whiteStyle),
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
