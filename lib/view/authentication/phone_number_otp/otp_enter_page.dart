import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:pinput/pinput.dart';
import 'package:view360/api/authentication/phone_otp/validate_otp_api.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/authentication/validate_otp/validate_otp_model.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class OtpEnterPage extends StatelessWidget {
  final String dialCode;
  final String phoneNumber;
  OtpEnterPage({super.key, required this.dialCode, required this.phoneNumber});

  final ValidateOtpApi validateOtpApi = Get.put(ValidateOtpApi());
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'OTP Verification'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 66,
                width: 366,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppStyle.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    width10,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.phone, color: Colors.white, size: 18),
                    ),
                    Text(
                      "Enter OTP".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: otpController,
                    length: 6,
                    validator: (s) =>
                        s!.length == 6 ? null : 'Enter 6-digit OTP'.tr,
                    pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                    showCursor: true,
                    onCompleted: (pin) {},
                  ),
                ),
              ),
              height20,
              SizedBox(
                height: 45,
                width: 210,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppStyle.primary,
                  ),
                  onPressed: () => _verifyOtp(context),
                  child: Obx(
                    () => validateOtpApi.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Signin'.tr, style: whiteStyle),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Back to Login".tr,
                  style: TextStyle(
                    color: AppStyle.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOtp(BuildContext context) async {
    final model1 = ValidateOtpModel(
      dialCode: dialCode,
      phone: phoneNumber,
      otp: otpController.text,
    );

    if (otpController.text.length == 6) {
      try {
        await validateOtpApi.validateOtp(model1);
        if (validateOtpApi.success.value == true) {
          Get.off(() => BottomNav());
          if (context.mounted) {
            SnackbarHelperTop.showSnackBar(
              context,
              'OTP verified successfully'.tr,
              color: Colors.green,
            );
          }
        } else {
          if (context.mounted) {
            SnackbarHelperTop.showSnackBar(
              context,
              validateOtpApi.message.value.tr,
              color: Colors.red,
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'An error occurred. Please try again.'.tr,
            color: Colors.red,
          );
        }
      }
    } else {
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(
          context,
          'Enter 6-digit OTP'.tr,
          color: Colors.red,
        );
      }
    }
  }
}
