// Individual form
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:view360/api/authentication/verification_by_sms/email_verification/email_verification_api.dart';
import 'package:view360/api/authentication/registration/individual.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/authentication/registration/individual_register_model.dart';
import 'package:view360/model/profile_details/profile_details_model.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/authentication/registration/state/file_upload/file_upload_state.dart';
import 'package:view360/view/widgets/image_picker_download/image_download.dart';
import 'package:view360/view/widgets/image_picker_download/image_picker_all.dart';

import '../../../../api/authentication/verification_by_sms/phone_otp_sms_verification/phone_otp_sms.dart';
import '../../../../common/theme/colors.dart';
import '../../../../common/theme/style.dart';
import '../../../widgets/password_rules/password_rules.dart';

bool isOtpDialogOpen = false;

class IndividualFormWithoutToken extends ConsumerStatefulWidget {
  //check page id for coming from edit profile or loginpage
  final int checkPageID;
  //constructor
  const IndividualFormWithoutToken({super.key, required this.checkPageID});

  //-----------------------------------------------------------------------------
  @override
  ConsumerState<IndividualFormWithoutToken> createState() =>
      _IndividualFormWithoutTokenState();
}

class _IndividualFormWithoutTokenState
    extends ConsumerState<IndividualFormWithoutToken> {
  final EditProfile editProfile = Get.put(EditProfile());

  final checkboxProvider = StateProvider<bool>((ref) => false);
  final _formKey = GlobalKey<FormState>();
  final PickImageGetX filePickerNotifier = Get.put(PickImageGetX());
  final FilesUploadGetX filesUploadGetXController = Get.put(FilesUploadGetX());
  final EmailVerificationApi emailVerificationApi = Get.put(
    EmailVerificationApi(),
  );
  final ValidateEmailOTP validateEmailOTP = Get.put(ValidateEmailOTP());
  final PhoneOtpSmsVerify phoneOtpSmsVerify = Get.put(PhoneOtpSmsVerify());
  final ValidatePhoneSMSOTP validatePhoneSMSOTP = Get.put(
    ValidatePhoneSMSOTP(),
  );
  //-----------------------------------------------------------------------------

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  final IndividualRegistrationController individualRegistrationController =
      Get.put(IndividualRegistrationController());

  //

  Map<String, bool> rulesStatus = {
    '8+': false,
    'a-z': false,
    'A-Z': false,
    '0-9': false,
    '!#@': false,
  };

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_updateValidation);
  }

  void _updateValidation() {
    final updated = validatePassword(passwordController.text);
    setState(() {
      rulesStatus = updated;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Map<String, bool> validatePassword(String password) {
    return {
      '8+': password.length >= 8,
      'a-z': RegExp(r'[a-z]').hasMatch(password),
      'A-Z': RegExp(r'[A-Z]').hasMatch(password),
      '0-9': RegExp(r'\d').hasMatch(password),
      '!#@': RegExp(r'[!@#\$&*~]').hasMatch(password),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkPageID == 1) {
      final AsyncValue<ProfileDetailsModel> profileState = ref.watch(
        auctionResponseProviderProfile,
      );
      if (profileState.value != null &&
          widget.checkPageID == 1 &&
          profileState.value!.data.isCompany == 0) {
        final profileData = profileState.value!.data;
        nameController.text = profileData.name;
        phoneNumberController.text = profileData.mobile;
        emailController.text = profileData.email;
        usernameController.text = profileData.username;
        idNumberController.text = profileData.residentCardNumber;
        bankNameController.text = profileData.bank;
        accountNumberController.text = profileData.accountNumber;

        // Ensure fileIdNumber is a String before using it
        if (profileData.fileIdNumber is String &&
            profileData.fileIdNumber.startsWith('http')) {
          downloadImage(profileData.fileIdNumber).then((file) {
            filesUploadGetXController.attachIDFront.value = file;
          });
        } else {
          filesUploadGetXController.attachIDFront.value = File(
            profileData.fileIdNumber.toString(),
          );
        }

        filesUploadGetXController.attachIDFront.value = File(
          profileData.fileIdNumber.toString(),
        );
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          registrationField(
            hinttext: 'Enter your name'.tr,
            controller: nameController,
            label: 'Name'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Name'.tr;
              }
              return null;
            },
          ),

          registrationField(
            textinput: TextInputType.emailAddress,
            hinttext: 'Enter your email'.tr,
            controller: emailController,
            label: 'Email'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Email'.tr;
              }
              return null;
            },
          ),
          registrationField(
            hinttext: 'Enter your username'.tr,
            controller: usernameController,
            label: 'Username'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Username'.tr;
              }
              return null;
            },
          ),

          //* phone number verification---------------------------------------------------
          registrationField(
            textinput: TextInputType.number,
            hinttext: 'Enter your phone number'.tr,
            controller: phoneNumberController,
            label: 'Phone Number'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Phone Number'.tr;
              }
              return null;
            },
          ),

          registrationField(
            hinttext: 'Enter your password'.tr,
            controller: passwordController,
            label: 'Password'.tr,
            validator: (value) {
              if (value == null && widget.checkPageID == 0 ||
                  value!.isEmpty && widget.checkPageID == 0) {
                return 'Please Enter Password'.tr;
              }
              return null;
            },
          ),
          // need validation design for password which is smallcase, uppercase, number, special character
          height05,
          PasswordRulesWidgetA(rules: rulesStatus),

          PasswordRules(),
          registrationField(
            hinttext: 'Enter your confirm password'.tr,
            controller: confirmPasswordController,
            label: 'Confirm password'.tr,
            validator: (value) {
              if (value == null && widget.checkPageID == 0 ||
                  value!.isEmpty && widget.checkPageID == 0) {
                return 'Please enter Confirm password'.tr;
              }
              return null;
            },
          ),
          PasswordRules(),
          registrationField(
            hinttext: 'Enter your ID number'.tr,
            controller: idNumberController,
            label: 'ID Number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageID == 0 ||
                  value!.isEmpty && widget.checkPageID == 0) {
                return 'Please enter ID Number'.tr;
              }
              return null;
            },
          ),

          //
          Obx(
            () => fileUploadField(
              fileName:
                  filesUploadGetXController.attachIDFront.value?.path
                      .split('/')
                      .last ??
                  "No file selected...".tr,
              label: 'Upload ID'.tr,
              ontap: () {
                filePickerNotifier.pickPdf(
                  filesUploadGetXController.attachIDFront,
                );
              },
            ),
          ),

          registrationField(
            hinttext: 'Enter your bank name'.tr,
            controller: bankNameController,
            label: 'Bank name'.tr,
            validator: (value) {
              if (value == null && widget.checkPageID == 0 ||
                  value!.isEmpty && widget.checkPageID == 0) {
                return 'Please enter Bank name'.tr;
              }
              return null;
            },
          ),
          registrationField(
            textinput: TextInputType.number,
            hinttext: 'Enter your account number'.tr,
            controller: accountNumberController,
            label: 'Account number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageID == 0 ||
                  value!.isEmpty && widget.checkPageID == 0) {
                return 'Please enter Account number'.tr;
              }
              return null;
            },
          ),
          height10,
          //checking which page come from showing terms and condition (0 means it is from Login page)
          if (widget.checkPageID == 0)
            Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final isTrue = ref.watch(checkboxProvider);

                    return Checkbox(
                      value: isTrue,
                      onChanged: (value) {
                        ref.read(checkboxProvider.notifier).state = value!;
                      },
                    );
                  },
                ),
                Text('Please accept the terms and conditions'.tr),
                height10,
              ],
            ),

          //submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.checkPageID == 0) {
                  _submit(context, ref);
                } else {}
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(darkBlue),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Obx(
                () => editProfile.isLoading.value == true
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: white,
                          strokeWidth: 1,
                        ),
                      )
                    : Text(
                        //checking which page come from showing terms and condition (0 means it is from Login page)
                        widget.checkPageID == 0 ? 'Signup'.tr : 'Submit'.tr,
                        style: whiteStyle,
                      ),
              ),
            ),
          ),
          height05,

          //checking which page come from showing terms and condition (0 means it is from Login page)
          if (widget.checkPageID == 0)
            //------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'.tr),
                width05,
                InkWell(
                  onTap: () {
                    Get.offAll(() => LoginPage());
                  },
                  child: Text('Login'.tr, style: TextStyle(color: darkBlue)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  //verify otp method for phone verification

  Future<void> verifyOTPPhone(BuildContext context, WidgetRef ref) async {
    if (isOtpDialogOpen) return; // Prevent opening multiple dialogs.

    final otpControllerPhone = TextEditingController();

    isOtpDialogOpen = true;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Please enter OTP'.tr, style: bold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Pinput(
                controller: otpControllerPhone,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
              height10,
              Text(
                'Please enter OTP sent to your email'.tr,
                style: smallFontSize12,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final model = OtpSendPhoneModel(
                      otp: otpControllerPhone.text,
                      type: 'sms',
                    );
                    await validatePhoneSMSOTP.validateSMSPhoneOtp(model);

                    if (validatePhoneSMSOTP.success.value == true) {
                      ref.invalidate(auctionResponseProviderProfile);
                      isOtpDialogOpen = false;
                      Get.back();
                      Get.snackbar(
                        'Success'.tr,
                        validatePhoneSMSOTP.message.value,
                        colorText: white,
                        backgroundColor: Colors.green,
                      );
                    } else {
                      Get.snackbar(
                        'Error'.tr,
                        validatePhoneSMSOTP.message.value,
                        colorText: white,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(darkBlue),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Obx(
                    () => validatePhoneSMSOTP.isLoading.value
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: white,
                              strokeWidth: 1,
                            ),
                          )
                        : Text('Verify'.tr, style: whiteStyle),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then(
      (_) => isOtpDialogOpen = false,
    ); // Ensure state resets when dialog closes
  }

  //----------------------------------------------------------------------------

  Future<void> verifyOTP(BuildContext context, WidgetRef ref) async {
    if (isOtpDialogOpen) return; // Prevent opening multiple dialogs.

    final otpController = TextEditingController();

    isOtpDialogOpen = true;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Please enter OTP'.tr, style: bold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
              height10,
              Text(
                'Please enter OTP sent to your email'.tr,
                style: smallFontSize12,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final model = OtpSendEmailModel(
                      otp: otpController.text,
                      type: 'email',
                    );
                    await validateEmailOTP.validateEmailOtp(model);

                    if (validateEmailOTP.success.value == true) {
                      // profilestate.refresh()
                      isOtpDialogOpen = false; // Reset when closed
                      ref.invalidate(auctionResponseProviderProfile);
                      Get.back();
                      Get.snackbar(
                        'Success'.tr,
                        validateEmailOTP.message.value,
                        colorText: white,
                        backgroundColor: Colors.green,
                      );
                    } else {
                      Get.snackbar(
                        'Error'.tr,
                        validateEmailOTP.message.value,
                        colorText: white,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(darkBlue),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Obx(
                    () => validateEmailOTP.isLoading.value
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: white,
                              strokeWidth: 1,
                            ),
                          )
                        : Text('Verify'.tr, style: whiteStyle),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then(
      (_) => isOtpDialogOpen = false,
    ); // Ensure state resets when dialog closes
  }

  //submit method-------for first time register

  void _submit(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final email = emailController.text;
      final username = usernameController.text;
      final phoneNumber = phoneNumberController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final idNumber = idNumberController.text;
      final bankName = bankNameController.text;
      final accountNumber = accountNumberController.text;

      final fileNumberAttach = filesUploadGetXController.attachIDFront.value;

      if (fileNumberAttach == null) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(context, 'Please upload ID'.tr);
          return;
        }
      }

      final model = IndividualRegisterModel(
        countryCode: '+968',
        name: name,
        email: email,
        username: username,
        mobile: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        residentCardNumber: idNumber,
        accountNumber: accountNumber,
        bank: bankName,
        isCompany: 0,
        fileIdNumber: fileNumberAttach.toString(),
      );

      // print(model.toJson());

      final isTrue = ref.watch(checkboxProvider);

      if (!isTrue) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Please accept terms and condition'.tr,
          );
          return;
        }
      }

      if (passwordController.text != confirmPasswordController.text) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(context, 'Password does not match'.tr);
          return;
        }
      }

      //password 8 length and small letter, capital letter, number, special character

      if (passwordController.text.length < 8) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Password must be at least 8 characters'.tr,
          );
          return;
        }
      }

      //check password strength, smallletter, capital, number, special character with same time
      if (!RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
      ).hasMatch(passwordController.text)) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Password must contain at least one uppercase letter, one lowercase letter, one number and one special character'
                .tr,
          );
          return;
        }
      }

      try {
        await individualRegistrationController.registerClientIndividual(
          model,
          filesUploadGetXController.attachIDFront.value!,
        );

        if (individualRegistrationController.success.value == true &&
            individualRegistrationController.token.value.isNotEmpty) {
          if (context.mounted) {
            Get.offAll(() => LoginPage());
            SnackbarHelperTop.showSnackBar(
              context,
              'Registration successful'.tr,
              color: Colors.green,
            );
          }
        } else {
          if (context.mounted) {
            SnackbarHelperTop.showSnackBar(
              context,
              individualRegistrationController.erroMessage.value,
              color: Colors.red,
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Registration failed'.tr,
            color: Colors.red,
          );
        }
      }
    }
  }

  //-----------------------------------------------------------------------------

  //------------------------------------------------------------------------------

  //widgets for bank transfer

  Widget registrationField({
    required String label,
    required String? Function(String?) validator,
    required TextEditingController controller,
    required String hinttext,
    TextInputType? textinput,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          TextFormField(
            keyboardType: textinput,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hinttext,
              hintStyle: TextStyle(fontSize: 12),
              filled: true,
              fillColor: const Color.fromARGB(97, 158, 158, 158),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget fileUploadField({
    required String label,
    required VoidCallback ontap,
    required String fileName,
    required,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber[700], // Match button color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: TextButton.icon(
                  onPressed: ontap,
                  icon: const Icon(Icons.upload, size: 16, color: Colors.black),
                  label: Text(
                    "Select File".tr,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.teal, // Match image preview color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

//

class PasswordRulesWidgetA extends StatelessWidget {
  final Map<String, bool> rules;

  const PasswordRulesWidgetA({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 5,
      children: rules.entries.map((entry) {
        return _ruleBox(entry.key, isValid: entry.value);
      }).toList(),
    );
  }

  Widget _ruleBox(String label, {required bool isValid}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: isValid ? Colors.green : Colors.red,
          //   width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isValid ? Colors.green : Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
