// Individual form
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/enrollment_payment_screen/widgets/file_upload_getx_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:view360/api/authentication/verification_by_sms/email_verification/email_verification_api.dart';
import 'package:view360/api/authentication/registration/individual.dart';
import 'package:view360/api/profile_details_api/profile_details_api.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/authentication/registration/individual_register_model.dart';
import 'package:view360/model/profile_details/profile_details_model.dart';
import 'package:view360/view/authentication/login/login_page.dart';
import 'package:view360/view/widgets/image_picker_download/image_download.dart';
import '../../../api/authentication/verification_by_sms/phone_otp_sms_verification/phone_otp_sms.dart';
import '../../../common/theme/colors.dart';
import '../../../common/theme/style.dart';
import '../../widgets/image_picker_download/image_picker_all.dart';
import '../../widgets/password_rules/password_rules.dart';
import 'state/file_upload/file_upload_state.dart';

bool isOtpDialogOpen = false;

class IndividualForm extends ConsumerStatefulWidget {
  //check page id for coming from edit profile or loginpage
  final int checkPageID;
  //constructor
  const IndividualForm({super.key, required this.checkPageID});

  //-----------------------------------------------------------------------------
  @override
  ConsumerState<IndividualForm> createState() => _IndividualFormState();
}

class _IndividualFormState extends ConsumerState<IndividualForm> {
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

  final EditProfile editProfile = Get.put(EditProfile());
  bool ischeck = false;

  @override
  void initState() {
    super.initState();

    // Delay the initialization until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initializeFormData();
    });
  }

  Future<void> _initializeFormData() async {
    final profile = ref.read(auctionResponseProviderProfile);
    if (widget.checkPageID == 1 && profile.value != null) {
      final profileData = profile.value!.data;

      // Update controllers synchronously
      nameController.text = profileData.name ?? '';
      phoneNumberController.text = profileData.mobile ?? '';
      emailController.text = profileData.email ?? '';
      usernameController.text = profileData.username ?? '';
      idNumberController.text = profileData.residentCardNumber ?? '';
      bankNameController.text = profileData.bank ?? '';
      accountNumberController.text = profileData.accountNumber ?? '';

      // Handle file download asynchronously
      if (profileData.fileIdNumber is String &&
          profileData.fileIdNumber.startsWith('http')) {
        try {
          final file = await downloadImage(profileData.fileIdNumber);
          if (mounted) {
            filesUploadGetXController.attachIDFront.value = file;
          }
        } catch (e) {
          debugPrint('Error downloading image: $e');
        }
      } else {
        filesUploadGetXController.attachIDFront.value = File(
          profileData.fileIdNumber.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ProfileDetailsModel> profileState = ref.watch(
      auctionResponseProviderProfile,
    );

    //   if(ischeck==false){

    //   if (profileState.value != null &&
    //       widget.checkPageID == 1 &&
    //       profileState.value!.data.isCompany == 0) {
    //     final profileData = profileState.value!.data;
    //     nameController.text = profileData.name;
    //     phoneNumberController.text = profileData.mobile;
    //     emailController.text = profileData.email;
    //     usernameController.text = profileData.username;
    //     idNumberController.text = profileData.residentCardNumber;
    //     bankNameController.text = profileData.bank;
    //     accountNumberController.text = profileData.accountNumber;

    //     // Ensure fileIdNumber is a String before using it
    //     if (profileData.fileIdNumber is String &&
    //         profileData.fileIdNumber.startsWith('http')) {
    //       downloadImage(profileData.fileIdNumber).then((file) {
    //         filesUploadGetXController.attachIDFront.value = file;
    //       });
    //     } else {
    //       filesUploadGetXController.attachIDFront.value =
    //           File(profileData.fileIdNumber.toString());
    //     }

    //     filesUploadGetXController.attachIDFront.value =
    //         File(profileData.fileIdNumber.toString());

    //         ischeck=true;
    //   }
    //   }

    final emailverified = profileState.value!.data.emailVerifiedAt;
    final phoneVerified = profileState.value!.data.mobileVerifiedAt;

    print(phoneVerified);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          registrationField(
            hintText: 'Enter Name'.tr,
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
            hintText: 'Enter Email'.tr,
            controller: emailController,
            label: 'Email'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Email'.tr;
              }
              return null;
            },
          ),

          //* email verification--------------------------------------------
          if (widget.checkPageID == 1)
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
            hintText: 'Enter Username'.tr,
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
            hintText: 'Enter Phone Number'.tr,
            controller: phoneNumberController,
            label: 'Phone Number'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Phone Number'.tr;
              }
              return null;
            },
          ),
          if (widget.checkPageID == 1)
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

          //   PasswordRules(), // Show visual password rules here
          registrationField(
            onChanged: (value) {
              print(value);
            },
            hintText: 'Enter Password'.tr,
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
          PasswordRules(),
          registrationField(
            hintText: 'Enter Confirm Password'.tr,
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
          // PasswordRules(),
          registrationField(
            hintText: 'Enter ID Number'.tr,
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
            () => FileUploadFielMethod(
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
            hintText: 'Enter Bank Name'.tr,
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
            hintText: 'Enter Account Number'.tr,
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(checkboxProvider.notifier).state = value!;
                        });
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
                print(profileState.value!.data.name);
                if (widget.checkPageID == 0) {
                  _submit(context, ref);
                } else {
                  print('Edit Profile submission initiated');
                  //---------------------------------
                  _submitForEditProfile(
                    context,
                    ref,
                    profileState.value!.data.isCompany ?? 0,
                  );
                  //---------------------------------
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

  //submit method-------for register

  //-----------------------------------------------------------------------------
  //submit method-------for register

  //-----------------------------------------------------------------------------
  void _submitForEditProfile(
    BuildContext context,
    WidgetRef ref,
    int isCompany,
  ) async {
    print('[_submitForEditProfile] called with isCompany: $isCompany');

    if (isCompany == 1) {
      print('[_submitForEditProfile] user is company, aborting.');
      SnackbarHelperTop.showSnackBar(
        context,
        'You are not registered with an Individual, so please register as an individual'
            .tr,
      );
      return;
    }
    final name = nameController.text;
    final email = emailController.text;
    final username = usernameController.text;
    final phoneNumber = phoneNumberController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final idNumber = idNumberController.text;
    final bankName = bankNameController.text;
    final accountNumber = accountNumberController.text;

    print(
      '[_submitForEditProfile] inputs -> name: $name, email: $email, username: $username, phone: $phoneNumber, id: $idNumber, bank: $bankName, account: $accountNumber',
    );

    final fileNumberAttach = filesUploadGetXController.attachIDFront.value;
    print('[_submitForEditProfile] attachIDFront raw: $fileNumberAttach');

    if (fileNumberAttach == null) {
      print('[_submitForEditProfile] no file attached, showing snackbar.');
      if (context.mounted) {
        SnackbarHelperTop.showSnackBar(context, 'Please upload ID'.tr);
        return;
      }
    }
    //validation
    // Validation for empty fields
    if (idNumber.isEmpty) {
      SnackbarHelperTop.showSnackBar(
        context,
        'Please enter ID Number'.tr,
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

    // If the file is a network URL, download it and get the local file path
    File localFile;
    if (fileNumberAttach.toString().startsWith('http')) {
      try {
        print(
          '[_submitForEditProfile] downloading file from URL: ${fileNumberAttach.toString()}',
        );
        localFile = await downloadImage(fileNumberAttach.toString());
        print(
          '[_submitForEditProfile] downloaded file path: ${localFile.path}',
        );
      } catch (e) {
        print('[_submitForEditProfile] error downloading file: $e');
        rethrow;
      }
    } else {
      localFile = filesUploadGetXController.attachIDFront.value!;
      print('[_submitForEditProfile] using local file path: ${localFile.path}');
    }

    final model = IndividualRegisterModel(
      countryCode: '+968',
      name: name.isNotEmpty ? name : '',
      email: email.isNotEmpty ? email : '',
      username: username.isNotEmpty ? username : '',
      mobile: phoneNumber.isNotEmpty ? phoneNumber : '',
      password: password.isNotEmpty ? password : '',
      confirmPassword: confirmPassword.isNotEmpty ? confirmPassword : '',
      residentCardNumber: idNumber.isNotEmpty ? idNumber : '',
      accountNumber: accountNumber.isNotEmpty ? accountNumber : '',
      bank: bankName.isNotEmpty ? bankName : '',
      isCompany: 0,
      fileIdNumber: localFile.path,
    );

    try {
      if (filesUploadGetXController.attachIDFront.value != null) {
        print(
          '[_submitForEditProfile] calling editProfile.editProfile with model: ${model.toJson()} and file: ${filesUploadGetXController.attachIDFront.value!.path}',
        );
        await editProfile.editProfile(
          model,
          filesUploadGetXController.attachIDFront.value!,
        );
      } else {
        print(
          '[_submitForEditProfile] attachIDFront was null before calling editProfile.',
        );
        if (context.mounted) {
          SnackbarHelperTop.showSnackBar(
            context,
            'Please upload ID'.tr,
            color: Colors.red,
          );
        }
      }

      print(
        '[_submitForEditProfile] editProfile.success: ${editProfile.success.value}, erroMessage: ${editProfile.erroMessage.value}',
      );

      if (editProfile.success.value == true) {
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
            editProfile.erroMessage.value,
            color: Colors.red,
          );
        }
      }
    } catch (e) {
      print('[_submitForEditProfile] Exception: $e');
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
  // void _submitForEditProfile(
  //   BuildContext context,
  //   WidgetRef ref,
  //   int isCompany,
  // ) async {
  //   if (isCompany == 1) {
  //     SnackbarHelperTop.showSnackBar(
  //       context,
  //       'You are not registered with an Individual, so please register as an individual'
  //           .tr,
  //     );
  //     return;
  //   }
  //   final name = nameController.text;
  //   final email = emailController.text;
  //   final username = usernameController.text;
  //   final phoneNumber = phoneNumberController.text;
  //   final password = passwordController.text;
  //   final confirmPassword = confirmPasswordController.text;
  //   final idNumber = idNumberController.text;
  //   final bankName = bankNameController.text;
  //   final accountNumber = accountNumberController.text;

  //   final fileNumberAttach = filesUploadGetXController.attachIDFront.value;
  //   if (fileNumberAttach == null) {
  //     if (context.mounted) {
  //       SnackbarHelperTop.showSnackBar(context, 'Please upload ID'.tr);
  //       return;
  //     }
  //   }

  //   // If the file is a network URL, download it and get the local file path
  //   File localFile;
  //   if (fileNumberAttach.toString().startsWith('http')) {
  //     localFile = await downloadImage(fileNumberAttach.toString());
  //   } else {
  //     localFile = filesUploadGetXController.attachIDFront.value!;
  //   }

  //   final model = IndividualRegisterModel(
  //     countryCode: '+968',
  //     name: name.isNotEmpty ? name : '',
  //     email: email.isNotEmpty ? email : '',
  //     username: username.isNotEmpty ? username : '',
  //     mobile: phoneNumber.isNotEmpty ? phoneNumber : '',
  //     password: password.isNotEmpty ? password : '',
  //     confirmPassword: confirmPassword.isNotEmpty ? confirmPassword : '',
  //     residentCardNumber: idNumber.isNotEmpty ? idNumber : '',
  //     accountNumber: accountNumber.isNotEmpty ? accountNumber : '',
  //     bank: bankName.isNotEmpty ? bankName : '',
  //     isCompany: 0,
  //     fileIdNumber: localFile.path,
  //   );

  //   try {
  //     if (filesUploadGetXController.attachIDFront.value != null) {
  //       print(model.toJson());
  //       await editProfile.editProfile(
  //         model,
  //         filesUploadGetXController.attachIDFront.value!,
  //       );
  //     } else {
  //       if (context.mounted) {
  //         SnackbarHelperTop.showSnackBar(
  //           context,
  //           'Please upload ID'.tr,
  //           color: Colors.red,
  //         );
  //       }
  //     }

  //     if (editProfile.success.value == true) {
  //       ref.invalidate(auctionResponseProviderProfile);
  //       Get.back();

  //       if (context.mounted) {
  //         SnackbarHelperTop.showSnackBar(
  //           context,
  //           'Profile Updated successfully'.tr,
  //           color: Colors.green,
  //         );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         SnackbarHelperTop.showSnackBar(
  //           context,
  //           editProfile.erroMessage.value,
  //           color: Colors.red,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Exception: $e');
  //     if (context.mounted) {
  //       SnackbarHelperTop.showSnackBar(
  //         context,
  //         'Update failed, please try again'.tr,
  //         color: Colors.red,
  //       );
  //     }
  //   }
  // }

  //------------------------------------------------------------------------------

  //widgets for bank transfer

  Widget registrationField({
    required String label,
    required String? Function(String?) validator,
    required TextEditingController controller,
    required String hintText,
    TextInputType? textInput,
    ValueChanged<String>? onChanged,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8), // Adjusted spacing for better alignment
          Text(
            label.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600, // Slightly bolder font
              color: Colors.black87, // Darker text color for better contrast
            ),
          ),
          const SizedBox(height: 6), // Adjusted spacing
          TextFormField(
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            keyboardType: textInput,
            decoration: InputDecoration(
              hintText: hintText.tr,
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

  Widget fileUploadField({
    required String label,
    required VoidCallback ontap,
    required String fileName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label.tr,
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
