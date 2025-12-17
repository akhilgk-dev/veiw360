import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/api/authentication/verification_by_sms/email_verification/email_verification_api.dart';
import 'package:view360/api/authentication/verification_by_sms/phone_otp_sms_verification/phone_otp_sms.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/authentication/registration/institution_register_model.dart';
import 'package:view360/model/profile_details/profile_details_model.dart';
import 'package:view360/view/authentication/registration/reg_without_token/indv.dart';
import 'package:view360/view/authentication/registration/state/file_upload/file_upload_state.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/file_upload_getx_widget.dart';
import 'package:view360/view/widgets/image_picker_download/image_download.dart';
import 'package:pinput/pinput.dart';
import '../../../api/authentication/registration/institution.dart';
import '../../widgets/image_picker_download/image_picker_all.dart';
import '../../widgets/password_rules/password_rules.dart';

class InstitutionForm extends ConsumerStatefulWidget {
  final int checkPageId;
  const InstitutionForm({super.key, required this.checkPageId});

  //----------------------------------------------------------------------------
  @override
  ConsumerState<InstitutionForm> createState() => _InstitutionFormState();
}

class _InstitutionFormState extends ConsumerState<InstitutionForm> {
  // Text editing controllers---------------------------------------------------
  final PickImageGetX filePickerNotifier = Get.put(PickImageGetX());
  final FilesUploadGetX filesUploadGetXController = Get.put(FilesUploadGetX());
  final _formKey = GlobalKey<FormState>();

  final InstitutionRegistrationController institutionRegistrationController =
      Get.put(InstitutionRegistrationController());

  final EditInstitutionApi editInstitutionApi = Get.put(EditInstitutionApi());
  final checkboxProvider = StateProvider<bool>((ref) => false);

  //------------------------------------------------------------------------------
  final nameController = TextEditingController();
  final authorityNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final idNumberController = TextEditingController();
  final bankController = TextEditingController();
  final accountNumberController = TextEditingController();
  final crNumberController = TextEditingController();
  final vatNumberController = TextEditingController();
  final EmailVerificationApi emailVerificationApi = Get.put(
    EmailVerificationApi(),
  );
  final ValidateEmailOTP validateEmailOTP = Get.put(ValidateEmailOTP());
  final PhoneOtpSmsVerify phoneOtpSmsVerify = Get.put(PhoneOtpSmsVerify());
  final ValidatePhoneSMSOTP validatePhoneSMSOTP = Get.put(
    ValidatePhoneSMSOTP(),
  );
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
    final AsyncValue<ProfileDetailsModel> profileState = ref.watch(
      auctionResponseProviderProfile,
    );
    final emailverified = profileState.value!.data.emailVerifiedAt;
    final phoneVerified = profileState.value!.data.mobileVerifiedAt;
    if (widget.checkPageId == 1) {
      if (profileState.value != null) {
        final profileData = profileState.value!.data;
        nameController.text = profileData.name ?? '';
        phoneController.text = profileData.mobile ?? '';
        emailController.text = profileData.email ?? '';
        usernameController.text = profileData.username ?? '';
        idNumberController.text = profileData.residentCardNumber ?? '';
        bankController.text = profileData.bank ?? '';
        accountNumberController.text = profileData.accountNumber ?? '';
        authorityNameController.text = profileData.authorityName ?? "";
        crNumberController.text = profileData.crNumber ?? '';
        vatNumberController.text = profileData.vatNumber ?? '';
        // Assuming you have a way to set the file paths for the file upload fields
        filesUploadGetXController.attachAuthorityID.value =
            profileData.fileAuthLetter is String &&
                profileData.fileAuthLetter.isNotEmpty
            ? File(profileData.fileAuthLetter)
            : File('');
        filesUploadGetXController.attachIDNumber.value =
            profileData.fileIdNumber is String &&
                profileData.fileIdNumber.isNotEmpty
            ? File(profileData.fileIdNumber)
            : File('');
        filesUploadGetXController.attachCRNumber.value =
            profileData.fileCrNumber is String &&
                profileData.fileCrNumber.isNotEmpty
            ? File(profileData.fileCrNumber)
            : File('');
        filesUploadGetXController.attachVATNumber.value =
            profileData.fileVatCertificate is String &&
                profileData.fileVatCertificate.isNotEmpty
            ? File(profileData.fileVatCertificate)
            : File('');
        // If the file is a network URL, download it and get the local file path
        if (profileData.fileAuthLetter is String &&
            profileData.fileAuthLetter.startsWith('http')) {
          downloadImage(profileData.fileAuthLetter).then((file) {
            filesUploadGetXController.attachAuthorityID.value = file;
          });
        } else {
          filesUploadGetXController.attachAuthorityID.value = File(
            profileData.fileAuthLetter.toString(),
          );
        }
        if (profileData.fileCrNumber is String &&
            profileData.fileCrNumber.startsWith('http')) {
          downloadImage(profileData.fileCrNumber).then((file) {
            filesUploadGetXController.attachCRNumber.value = file;
          });
        } else {
          filesUploadGetXController.attachCRNumber.value = File(
            profileData.fileCrNumber.toString(),
          );
        }
        if (profileData.fileVatCertificate is String &&
            profileData.fileVatCertificate.startsWith('http')) {
          downloadImage(profileData.fileVatCertificate).then((file) {
            filesUploadGetXController.attachVATNumber.value = file;
          });
        } else {
          filesUploadGetXController.attachVATNumber.value = File(
            profileData.fileVatCertificate.toString(),
          );
        }
        // If the file is a network URL, download it and get the local file path

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
      } else {
        nameController.text = '';
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          registrationField(
            hintText: 'Institution Name'.tr,
            controller: nameController,
            label: 'Institution Name'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter institution name'.tr;
              }
              return null;
            },
          ),
          registrationField(
            hintText: 'Authority Name'.tr,
            controller: authorityNameController,
            label: 'Authority Name'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter authority name'.tr;
              }
              return null;
            },
          ),

          //file upload field
          Obx(
            () => FileUploadFielMethod(
              fileName:
                  filesUploadGetXController.attachAuthorityID.value?.path
                      .split('/')
                      .last ??
                  "No file selected...".tr,
              label: 'Attach Authority ID'.tr,
              ontap: () {
                filePickerNotifier.pickPdf(
                  filesUploadGetXController.attachAuthorityID,
                );
              },
            ),
          ),

          registrationField(
            keyBoardType: TextInputType.number,
            hintText: 'Phone Number'.tr,
            controller: phoneController,
            label: 'Phone Number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter Phone Number'.tr;
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                phoneVerified == null ? Icons.clear : Icons.done,
                color: phoneVerified == null ? Colors.red : Colors.green,
                size: 12,
              ),
              width05,
              InkWell(
                onTap: () async {
                  await phoneOtpSmsVerify.sendSMSOtp();

                  if (phoneOtpSmsVerify.success.value == true) {
                    if (context.mounted) {
                      verifyOTPPhone(context, ref);
                    }
                    Get.snackbar(
                      'Success'.tr,
                      phoneOtpSmsVerify.message.value,
                      colorText: white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Error'.tr,
                      'Failed to send OTP. Please try again.'.tr,
                      colorText: white,
                      backgroundColor: Colors.red,
                    );
                  }
                },
                child: Obx(
                  () => phoneOtpSmsVerify.isLoading.value
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          phoneVerified == null
                              ? 'Please verify number'.tr
                              : 'Number verified'.tr,
                          style: TextStyle(
                            color: phoneVerified == null
                                ? Colors.red
                                : Colors.green,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
            ],
          ),
          registrationField(
            keyBoardType: TextInputType.emailAddress,
            hintText: 'Email'.tr,
            controller: emailController,
            label: 'Email'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter Email'.tr;
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                profileState.value!.data.emailVerifiedAt == null
                    ? Icons.clear
                    : Icons.done,
                color: profileState.value!.data.emailVerifiedAt == null
                    ? Colors.red
                    : Colors.green,
                size: 12,
              ),
              width05,
              InkWell(
                onTap: () async {
                  await emailVerificationApi.sendEmailOtp();

                  if (emailVerificationApi.success.value == true) {
                    if (context.mounted) {
                      verifyOTP(context, ref);
                    }

                    Get.snackbar(
                      'Success'.tr,
                      emailVerificationApi.message.value,
                      colorText: white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Error'.tr,
                      emailVerificationApi.message.value,
                      colorText: white,
                      backgroundColor: Colors.red,
                    );
                  }
                },
                child: Obx(
                  () => emailVerificationApi.isLoading.value
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          emailverified == null
                              ? 'Please verify email'.tr
                              : 'Email verified'.tr,
                          style: TextStyle(
                            color: emailverified == null
                                ? Colors.red
                                : Colors.green,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
            ],
          ),
          registrationField(
            hintText: 'Username'.tr,
            controller: usernameController,
            label: 'Username'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter Username'.tr;
              }
              return null;
            },
          ),
          registrationField(
            hintText: 'Password'.tr,
            controller: passwordController,
            label: 'Password'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please Enter Password'.tr;
              }
              return null;
            },
          ),

          height05,

          //password rules-------------
          PasswordRulesWidgetA(rules: rulesStatus),
          PasswordRules(),
          //---------------------------
          registrationField(
            hintText: 'Confirm Password'.tr,
            controller: confirmPasswordController,
            label: 'Confirm password'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter Confirm password'.tr;
              }
              return null;
            },
          ),
          registrationField(
            keyBoardType: TextInputType.numberWithOptions(signed: true),
            hintText: 'ID Number'.tr,
            controller: idNumberController,
            label: 'ID Number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter ID Number'.tr;
              }
              return null;
            },
          ),
          height10,
          height05,

          //* file upload field
          Obx(
            () => FileUploadFielMethod(
              fileName:
                  filesUploadGetXController.attachIDNumber.value?.path
                      .split('/')
                      .last ??
                  "No file selected...".tr,
              label: 'Attach ID Number'.tr,
              ontap: () {
                filePickerNotifier.pickPdf(
                  filesUploadGetXController.attachIDNumber,
                );
              },
            ),
          ),
          registrationField(
            hintText: 'Bank name'.tr,
            controller: bankController,
            label: 'Bank name'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter Bank name'.tr;
              }
              return null;
            },
          ),
          registrationField(
            keyBoardType: TextInputType.number,
            hintText: 'Account number'.tr,
            controller: accountNumberController,
            label: 'Account number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter Account number'.tr;
              }
              return null;
            },
          ),

          registrationField(
            keyBoardType: TextInputType.numberWithOptions(signed: true),
            hintText: 'CR Number'.tr,
            controller: crNumberController,
            label: 'CR Number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter CR Number'.tr;
              }
              return null;
            },
          ),
          Obx(
            () => FileUploadFielMethod(
              fileName:
                  filesUploadGetXController.attachCRNumber.value?.path
                      .split('/')
                      .last ??
                  "No file selected...".tr,
              label: 'Attach CR Number'.tr,
              ontap: () {
                filePickerNotifier.pickPdf(
                  filesUploadGetXController.attachCRNumber,
                );
              },
            ),
          ),
          registrationField(
            keyBoardType: TextInputType.numberWithOptions(signed: true),
            hintText: 'VAT Number'.tr,
            controller: vatNumberController,
            label: 'VAT Number'.tr,
            validator: (value) {
              if (value == null && widget.checkPageId == 0 ||
                  value!.isEmpty && widget.checkPageId == 0) {
                return 'Please enter VAT Number'.tr;
              }
              return null;
            },
          ),
          height05,

          Obx(
            () => FileUploadFielMethod(
              //*(file upload field)
              fileName:
                  filesUploadGetXController.attachVATNumber.value?.path
                      .split('/')
                      .last ??
                  "No file selected...".tr,
              label: 'Attach VAT Number'.tr,
              ontap: () {
                filePickerNotifier.pickPdf(
                  filesUploadGetXController.attachVATNumber,
                );
              },
            ),
          ),
          height10,
          if (widget.checkPageId == 0)
            //check checkPageID ==0 is coming for editprofile
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.checkPageId == 0) {
                  _submit(context, ref, 1);
                } else {
                  print(profileState.value!.data.isCompany);
                  _submitForEditProfile(
                    context,
                    ref,

                    profileState.value!.data.isCompany ?? 1,
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
                () => institutionRegistrationController.isLoading.value
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 0.7),
                      )
                    : Text(
                        widget.checkPageId == 0 ? 'Signup'.tr : 'Submit'.tr,
                        style: whiteStyle,
                      ),
              ),
            ),
          ),
          height05,
          if (widget.checkPageId == 0)
            //check checkPageID ==0 is coming for editprofile
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'.tr),
                width05,
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text('Login'.tr, style: TextStyle(color: darkBlue)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  //submit for first time register
  void _submit(BuildContext context, WidgetRef ref, int isCompany) async {
    // if (isCompany == 1) {
    //   SnackbarHelperTop.showSnackBar(
    //     context,
    //     'You are not registered with an Individual, so please register as an individual'
    //         .tr,
    //   );
    //   return;
    // }
    final name = nameController.text;
    final email = emailController.text;
    final username = usernameController.text;
    final phoneNumber = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final bankName = bankController.text;
    final accountNumber = accountNumberController.text;
    final authorityName = authorityNameController.text;
    final crNumber = crNumberController.text;
    final vatNumber = vatNumberController.text;
    final residentCardNumber = idNumberController.text;
    final fileIdNumber = filesUploadGetXController.attachIDNumber.value;
    final fileAuthLetter = filesUploadGetXController.attachAuthorityID.value;
    final fileCrNumber = filesUploadGetXController.attachCRNumber.value;
    final fileVatCertificate = filesUploadGetXController.attachVATNumber.value;
    final countryCode = '+968';

    if (_formKey.currentState!.validate() == false) {
      return;
    }

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
    // final fileNumberAttach = filesUploadGetXController.attachIDFront.value;
    // if (fileNumberAttach == null) {
    //   if (context.mounted) {
    //     SnackbarHelperTop.showSnackBar(context, 'Please upload ID'.tr);
    //     return;
    //   }
    // }

    // If the file is a network URL, download it and get the local file path
    // File localFile;
    // if (fileNumberAttach.toString().startsWith('http')) {
    //   localFile = await downloadImage(fileNumberAttach.toString());
    // } else {
    //   localFile = filesUploadGetXController.attachIDFront.value!;
    // }

    final model = InstitutionRegisterModel(
      name: name,
      countryCode: countryCode,
      mobile: phoneNumber,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      residentCardNumber: residentCardNumber,
      accountNumber: accountNumber,
      bank: bankName,
      authorityName: authorityName,
      crNumber: crNumber,
      vatNumber: vatNumber,
      isCompany: isCompany,
      fileIdNumber: fileIdNumber.toString(),
      fileAuthLetter: fileAuthLetter.toString(),
      fileCrNumber: fileCrNumber.toString(),
      fileVatCertificate: fileVatCertificate.toString(),
    );
    //print(model.toJson());
    try {
      // if (filesUploadGetXController.attachIDFront.value != null) {
      // //  print(model.toJson());

      // } else {
      //   if (context.mounted) {
      //     SnackbarHelperTop.showSnackBar(context, 'Please upload ID'.tr,
      //         color: Colors.red);
      //   }
      // }

      await institutionRegistrationController.registerClientInstitution(model);

      if (institutionRegistrationController.success.value == true) {
        ref.invalidate(auctionResponseProviderProfile);
        Get.back();

        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Profile Updated successfully'.tr,
            color: Colors.green,
          );
        }
      } else {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            institutionRegistrationController.erroMessage.value,
            color: Colors.red,
          );
        }
      }
    } catch (e) {
      debugPrint('Exception: $e');
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(
          context,
          'Update failed, please try again'.tr,
          color: Colors.red,
        );
      }
    }
  }

  //submit api method for edit profile
  void _submitForEditProfile(
    BuildContext context,
    WidgetRef ref,
    int isCompany,
  ) async {
    // if (isCompany == 1) {
    //   SnackbarHelperTop.showSnackBar(
    //     context,
    //     'You are not registered with an Individual, so please register as an individual'
    //         .tr,
    //   );
    //   return;
    // }
    final name = nameController.text;
    final email = emailController.text;
    final username = usernameController.text;
    final phoneNumber = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final bankName = bankController.text;
    final accountNumber = accountNumberController.text;
    final authorityName = authorityNameController.text;
    final crNumber = crNumberController.text;
    final vatNumber = vatNumberController.text;
    final residentCardNumber = idNumberController.text;
    final fileIdNumber = filesUploadGetXController.attachIDNumber.value;
    final fileAuthLetter = filesUploadGetXController.attachAuthorityID.value;
    final fileCrNumber = filesUploadGetXController.attachCRNumber.value;
    final fileVatCertificate = filesUploadGetXController.attachVATNumber.value;
    final countryCode = '+968';

    final fileNumberAttach = filesUploadGetXController.attachIDFront.value;
    if (fileNumberAttach == null ||
        fileCrNumber == null ||
        fileAuthLetter == null ||
        fileVatCertificate == null) {
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(context, 'Please upload documents'.tr);
        return;
      }
    }
    // Validation for empty fields
    if (fileCrNumber == null || fileCrNumber.path.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter Id'.tr,
        color: Colors.red,
      );
      return;
    }

    if (bankName.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter Bank Name'.tr,
        color: Colors.red,
      );
      return;
    }

    if (accountNumber.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter Account Number'.tr,
        color: Colors.red,
      );
      return;
    }
    if (crNumber.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter CR Number'.tr,
        color: Colors.red,
      );
      return;
    }
    if (vatNumber.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter VAT Number'.tr,
        color: Colors.red,
      );
      return;
    }

    // If the file is a network URL, download it and get the local file path
    File localFile;
    if (fileNumberAttach.toString().startsWith('http')) {
      localFile = await downloadImage(fileNumberAttach.toString());
    } else {
      localFile = filesUploadGetXController.attachIDFront.value!;
    }

    final model = InstitutionRegisterModel(
      name: name,
      countryCode: countryCode,
      mobile: phoneNumber,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      residentCardNumber: residentCardNumber,
      accountNumber: accountNumber,
      bank: bankName,
      authorityName: authorityName,
      crNumber: crNumber,
      vatNumber: vatNumber,
      isCompany: isCompany,
      fileIdNumber: fileIdNumber.toString(),
      fileAuthLetter: fileAuthLetter.toString(),
      fileCrNumber: fileCrNumber.toString(),
      fileVatCertificate: fileVatCertificate.toString(),
    );
    print(model.toJson());
    try {
      if (filesUploadGetXController.attachIDFront.value != null) {
        print(model.toJson());
        await editInstitutionApi.editProfileInstitution(model);
      } else {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Please upload ID'.tr,
            color: Colors.red,
          );
        }
      }

      if (editInstitutionApi.success.value == true) {
        ref.invalidate(auctionResponseProviderProfile);
        Get.back();

        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Profile Updated successfully'.tr,
            color: Colors.green,
          );
        }
      } else {
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            editInstitutionApi.erroMessage.value,
            color: Colors.red,
          );
        }
      }
    } catch (e) {
      debugPrint('Exception: $e');
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(
          context,
          'Update failed, please try again'.tr,
          color: Colors.red,
        );
      }
    }
  }

  Widget registrationField({
    //controller
    TextInputType? keyBoardType,
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required String hintText,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8), // Adjusted spacing for better alignment
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600, // Slightly bolder font
              color: Colors.black87, // Darker text color for better contrast
            ),
          ),
          const SizedBox(height: 6), // Adjusted spacing
          TextFormField(
            keyboardType: keyBoardType,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.grey, // Subtle hint text color
              ),
              filled: true,
              fillColor: Colors.white, // White background for modern look
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                borderSide: BorderSide(color: AppStyle.lightGray2, width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: AppStyle.lightGray2, width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppStyle.secondary, // Highlighted border
                  width: 1.2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.red, width: 0.8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 8), // Adjusted spacing
        ],
      ),
    );
  }

  // Widget fileUploadField({
  //   required String label,
  //   required Function() onTap,
  //   required String filename,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 10),
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //       ),
  //       const SizedBox(height: 4),
  //       Container(
  //         height: 40,
  //         decoration: BoxDecoration(
  //           color: Colors.grey[300],
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.amber[700],
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(8),
  //                   bottomLeft: Radius.circular(8),
  //                 ),
  //               ),
  //               child: TextButton.icon(
  //                 onPressed: onTap,
  //                 icon: const Icon(Icons.upload, size: 16, color: Colors.black),
  //                 label: Text(
  //                   "Select File".tr,
  //                   style: TextStyle(fontSize: 12, color: Colors.black),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //               child: Text(
  //                 filename,
  //                 style: TextStyle(fontSize: 12, color: Colors.black54),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Container(
  //               height: 40,
  //               width: 40,
  //               decoration: BoxDecoration(
  //                 color: Colors.teal,
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.image, color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 6),
  //     ],
  //   );
  // }
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
}
