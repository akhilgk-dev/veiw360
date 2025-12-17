import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/authentication/phone_otp/phone_otp_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/authentication/phone_otp/phone_otp.dart';
import 'package:view360/view/authentication/phone_number_otp/otp_enter_page.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

import '../../../common/theme/colors.dart';
import '../../../common/theme/style.dart';

class PhoneNumberOtpPage extends StatelessWidget {
  PhoneNumberOtpPage({super.key});
  final TextEditingController phoneController = TextEditingController();
  final String selectedCode = '+968';
  final PhoneOtpApi phoneOtpApi = Get.put(PhoneOtpApi());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: "Login with phone".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: AppStyle.blueButtonGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.phone,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Login with phone".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Enter your contact number".tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withAlpha(60),
                          width: .8,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              selectedCode,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                border: InputBorder.none,
                                hintText: 'Enter phone number'.tr,
                                hintStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (phoneController.text.isEmpty) {
                            SnackbarHelperTop.showSnackBar(
                              context,
                              'Please enter your phone number'.tr,
                              color: Colors.red,
                            );
                            return;
                          }

                          final model1 = OtpRequest(
                            label: 'Oman',
                            dialCode: '+968',
                            code: 'OM',
                            captchaToken: 'captchaToken',
                            type: 'whatsapp',
                            phone: phoneController.text,
                          );

                          try {
                            await phoneOtpApi.sendOtp(model1);

                            if (phoneOtpApi.success.value) {
                              Get.to(
                                () => OtpEnterPage(
                                  dialCode: '+968',
                                  phoneNumber: phoneController.text,
                                ),
                              );
                              if (context.mounted) {
                                SnackbarHelperTop.showSnackBar(
                                  context,
                                  'OTP sent successfully to your WhatsApp'.tr,
                                );
                              }
                            } else {
                              if (context.mounted) {
                                SnackbarHelperTop.showSnackBar(
                                  context,
                                  "${phoneOtpApi.message.value} please register one time"
                                      .tr,
                                  color: black,
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              SnackbarHelperTop.showSnackBar(
                                context,
                                'An error occurred: $e'.tr,
                                color: Colors.red,
                              );
                            }
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppStyle.bidButtonGradient,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Obx(
                              () => phoneOtpApi.isLoading.value
                                  ? SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Send OTP'.tr,
                                      style: whiteStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back to Login".tr,
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
