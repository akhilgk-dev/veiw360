import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/authentication/registration/forgot_password.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/authentication/login/widgets/carosal_widget.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

import '../../../common/theme/style.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController forgotPasswordController =
      TextEditingController();
  final ForgotPasswordApi forgotPasswordApi = Get.put(ForgotPasswordApi());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: "Forgot Password".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              height30,
              CarosalWidget(page: ""),
              SizedBox(height: 24),
              Center(
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
                    child: Form(
                      key: _formKey,
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
                                    Icons.lock_reset,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Forgot password?".tr,
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
                            "Enter your Username or email address to reset your password"
                                .tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 18),
                          TextFormField(
                            controller: forgotPasswordController,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your email/ Username'.tr
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 20,
                                color: AppStyle.primary,
                              ),
                              hintText: 'Email Address / Username'.tr,
                              hintStyle: const TextStyle(fontSize: 14),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppStyle.primary.withAlpha(60),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppStyle.primary.withAlpha(40),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppStyle.primary,
                                  width: 1.2,
                                ),
                              ),
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
                              onPressed: () {
                                _submit(context);
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
                                    () => forgotPasswordApi.isLoading.value
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
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
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await forgotPasswordApi.forgotPassword(forgotPasswordController.text);

      if (forgotPasswordApi.success.value == true) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            forgotPasswordApi.message.value,
          );
        }
        Get.back();
      } else {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Error sending password reset link'.tr,
          );
        }
      }
    }
  }
}
