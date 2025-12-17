// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/mzadcom_payment/mzad_bank_payment.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/authentication/registration/state/file_upload/file_upload_state.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/bank_transfer_widget_field.dart';
import 'package:view360/view/mzadcom_payment/payment_bottom_sheet.dart';
import 'package:view360/view/widgets/image_picker_download/image_picker_all.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/file_upload_getx_widget.dart';

class BankPaymentWidget extends StatefulWidget {
  const BankPaymentWidget({
    super.key,
    required this.totalAmount,
    required this.selectedAuctionPayments,
  });
  final double totalAmount;
  final List<SelectedAuction> selectedAuctionPayments;

  @override
  State<BankPaymentWidget> createState() => _BankPaymentWidgetState();
}

class _BankPaymentWidgetState extends State<BankPaymentWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController civilIdController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  // final TextEditingController bankAccountNumberController =
  //     TextEditingController();
  final TextEditingController beneficiaryNameController =
      TextEditingController();
  final TextEditingController receiptController = TextEditingController();

  final List<Map<String, dynamic>> receiptFields = [];
  final FilesUploadGetX filesUploadGetXController = Get.put(FilesUploadGetX());
  final PickImageGetX filePickerNotifier = Get.put(PickImageGetX());
  final MzadBankPayment mzadBankPaymentController = Get.put(MzadBankPayment());

  @override
  void initState() {
    super.initState();
    // Add one mandatory receipt field at initialization
    receiptFields.add({
      'textController': TextEditingController(),
      'fileController': Rx<File?>(null),
      'amountController':
          TextEditingController(), // Add controller for receipt amount
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BankTransferTextField(
              hinttext: 'Enter your bank name'.tr,
              controller: bankNameController,
              label: "Bank Name".tr,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter the bank name'.tr : null,
            ),

            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: AppStyle.lightGray3,

                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Receipts".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (receiptFields.length < 5)
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            receiptFields.add({
                              'textController': TextEditingController(),
                              'fileController': Rx<File?>(null),
                              'amountController':
                                  TextEditingController(), // Add new amount field
                            });
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: Text("Add Receipt".tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...receiptFields.asMap().entries.map((entry) {
              final index = entry.key;
              final field = entry.value;
              final TextEditingController textController =
                  field['textController'];
              final Rx<File?> fileController = field['fileController'];
              final TextEditingController amountController =
                  field['amountController']; // Controller for receipt amount
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BankTransferTextField(
                            hinttext: 'Enter receipt details'.tr,
                            controller: textController,
                            label: "Receipt".tr,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter receipt details'.tr
                                : null,
                          ),
                        ),
                      ),
                      if (receiptFields.length > 1)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              receiptFields.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),
                  BankTransferTextField(
                    hinttext: 'Enter receipt amount'.tr,
                    controller: amountController,
                    label: "Receipt Amount".tr,

                    validator: (value) => value!.isEmpty
                        ? 'Please enter receipt amount'.tr
                        : null,
                  ),
                  // const SizedBox(height: 16),
                  Obx(() {
                    final filename =
                        fileController.value?.path.split('/').last ??
                        'No file selected'.tr;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: FileUploadFielMethod(
                        label: "Upload File".tr,
                        fileName: filename,
                        ontap: () {
                          filePickerNotifier.pickPdf(fileController);
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 8),

                  // Add receipt amount field
                ],
              );
            }).toList(),

            const SizedBox(height: 46),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(250),
                  gradient: LinearGradient(colors: AppStyle.bidButtonGradient),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        receiptFields.isNotEmpty &&
                        receiptFields.every(
                          (field) => field['fileController'].value != null,
                        )) {
                      // Implement the submit logic here

                      mzadBankPaymentController.bankPayment(
                        widget.totalAmount,
                        widget.selectedAuctionPayments,
                        bankNameController.text.trim(),
                        "",
                        receiptFields,
                      );
                    } else {
                      SnackbarHelperTop.showSnackBar(
                        context,
                        receiptFields.any(
                              (field) => field['fileController'].value == null,
                            )
                            ? 'Please upload all required files.'.tr
                            : 'Please add receipt details.'.tr,
                        color: AppStyle.liteRed,
                      );
                    }
                  },
                  child: Obx(() {
                    if (mzadBankPaymentController.isLoading.value) {
                      return SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    } else {
                      if (mzadBankPaymentController.success.value) {
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          SnackbarHelper.showSnackBar(
                            context,
                            'Payment successful'.tr,
                            color: Colors.green,
                          );
                          if (mounted) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          // Navigator.of(context).pushAndRemoveUntil(
                          //   MaterialPageRoute(
                          //     builder: (_) => MzadcomPaymentScreen(),
                          //   ),
                          //   (route) => false,
                          // );
                        });

                        return Text(
                          "Success".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text(
                        "Submit".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
