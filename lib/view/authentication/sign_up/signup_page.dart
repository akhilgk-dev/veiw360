import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:view360/api/authentication/registration/sign_up.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/providers/signup_provider.dart';
import 'package:view360/view/authentication/registration/reg_without_token/indv.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:get/get.dart';
import 'package:view360/view/widgets/common_butttons/submit_button.dart';
import 'package:view360/view/widgets/password_rules/password_rules.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final nameController = TextEditingController();

  Map<String, bool> rulesStatus = {
    '8+': false,
    'a-z': false,
    'A-Z': false,
    '0-9': false,
    '!#@': false,
  };
  Map<String, bool> validatePassword(String password) {
    rulesStatus = {
      '8+': password.length >= 8,
      'a-z': RegExp(r'[a-z]').hasMatch(password),
      'A-Z': RegExp(r'[A-Z]').hasMatch(password),
      '0-9': RegExp(r'\d').hasMatch(password),
      '!#@': RegExp(r'[!@#\$&*~]').hasMatch(password),
    };
    return rulesStatus;
  }

  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpProvider);
    final event = ref.read(signUpProvider.notifier);
    return Scaffold(
      appBar: AppbarWidget(title: 'Registration'.tr),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppStyle.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      registrationField(
                        keyBoardType: TextInputType.text,
                        hintText: 'Name'.tr,
                        controller: nameController,
                        label: 'Name'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name'.tr;
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            margin: EdgeInsets.only(bottom: 6, right: 8),
                            width: 100,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: AppStyle.secondColor,
                                width: .3, // Border width
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppStyle.secondColor.withAlpha(50),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(
                                    0,
                                    3,
                                  ), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: SvgPicture.asset(
                                    'assets/images/oman_flag.svg',
                                  ),
                                ),
                                Text(
                                  '+968',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: registrationField(
                              keyBoardType: TextInputType.number,
                              hintText: 'Phone Number'.tr,
                              controller: phoneController,
                              label: 'Phone Number'.tr,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Phone Number'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      registrationField(
                        keyBoardType: TextInputType.text,
                        hintText: 'Username'.tr,
                        controller: usernameController,
                        label: 'Username'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Username'.tr;
                          }
                          return null;
                        },
                      ),
                      registrationField(
                        keyBoardType: TextInputType.text,
                        hintText: 'Email'.tr,
                        controller: emailController,
                        label: 'Email'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email'.tr;
                          } else if (!value.contains('@')) {
                            return 'Email must be valid'.tr;
                          }
                          return null;
                        },
                      ),
                      registrationField(
                        keyBoardType: TextInputType.visiblePassword,
                        hintText: 'Password'.tr,
                        controller: passwordController,
                        label: 'Password'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password'.tr;
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters'.tr;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          event.updatePassword(value);
                          validatePassword(value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          passwordController.text.isNotEmpty
                              ? PasswordRulesWidgetA(rules: rulesStatus)
                              : SizedBox(),
                          width05,
                          PasswordRules(),
                        ],
                      ),

                      registrationField(
                        hintText: 'Confirm Password'.tr,
                        controller: passwordConfirmationController,
                        label: 'Confirm password'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            'Please Enter Password'.tr;
                          }
                          return null;
                        },
                      ),
                      PasswordRules(),
                    ],
                  ),
                ),
                height50,

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => signUpController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : SubmitButton(
                            childWidget: Text(
                              "Register".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (passwordController.text !=
                                    passwordConfirmationController.text) {
                                  Get.snackbar(
                                    'Error'.tr,
                                    'Passwords do not match'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                  return;
                                } else {
                                  signUpController
                                      .signUpCommon(
                                        SignUpHeaders(
                                          name: nameController.text,
                                          username: usernameController.text,
                                          email: emailController.text,
                                          countryCode: '+968',
                                          mobile: phoneController.text,
                                          password: passwordController.text,
                                          passwordConfirmation:
                                              passwordConfirmationController
                                                  .text,
                                        ),
                                      )
                                      .then((value) {
                                        if (signUpController.success.value) {
                                          Get.offAll(() => BottomNav());
                                        } else {
                                          Get.snackbar(
                                            'Error'.tr,
                                            signUpController.errorMessage.value,
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                          );
                                        }
                                      });
                                }
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registrationField({
    //controller
    TextInputType? keyBoardType,
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required String hintText,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppStyle.secondColor,
              width: .3, // Border width
            ),
            boxShadow: [
              BoxShadow(
                color: AppStyle.secondColor.withAlpha(50),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,

            maxLength: keyBoardType == TextInputType.number ? 8 : null,
            keyboardType: keyBoardType,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 12, color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              counterText: "",
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

// class CustomTextForm extends StatelessWidget {
//   CustomTextForm({
//     super.key,
//     TextInputType? keyBoardType,
//     required TextEditingController controller,
//     required String label,
//     required String? Function(String?) validator,
//     required String hintText,
//     required String? Function(String?)? onChanged,
//   });

//   late TextInputType? keyBoardType;
//   late TextEditingController controller;
//   late String label;
//   late String? Function(String?) validator;
//   late String hintText;
//   late String? Function(String?)? onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 10),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(height: 4),
//           Container(
//             decoration: BoxDecoration(
//               color: AppStyle.white,
//               borderRadius: BorderRadius.circular(8.0),
//               border: Border.all(
//                 color: AppStyle.secondColor,
//                 width: .3, // Border width
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppStyle.secondColor.withAlpha(50),
//                   spreadRadius: 1,
//                   blurRadius: 3,
//                   offset: const Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//             ),
//             child: TextFormField(
//               autovalidateMode: AutovalidateMode.onUserInteraction,

//               maxLength: keyBoardType == TextInputType.number ? 8 : null,
//               keyboardType: keyBoardType,
//               controller: controller,
//               validator: validator,
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 hintStyle: TextStyle(fontSize: 12, color: Colors.black54),
//                 filled: true,
//                 fillColor: AppStyle.white,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 5,
//                   horizontal: 10,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 counterText: "",
//               ),
//               onChanged: onChanged,
//             ),
//           ),
//           const SizedBox(height: 6),
//         ],
//       ),
//     );
//   }
// }
