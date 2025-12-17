import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:view360/api/active_auctions/active_auctions_api.dart';
import 'package:view360/api/authentication/login/login_api.dart';
import 'package:view360/common/get_device_info/get_device_info.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/common/utils/helpers/shared_pref.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/view/authentication/login/state/login_state.dart';
import 'package:view360/view/authentication/sign_up/signup_page.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import 'package:view360/view/splash_screen/animation_background.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:view360/view/widgets/token/token_checking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/authentication/login/login_model.dart';
import 'login_type/fingerprint.dart';
import 'login_type/guest_login.dart';
import 'login_type/phone_number_login.dart';
import 'widgets/forgotpassword.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RememberMeState rememberMeState = Get.put(RememberMeState());

  final LoginApi loginApi = Get.put(LoginApi());

  final formKey = GlobalKey<FormState>();

  //single state
  final isObscureProvider = StateProvider<bool>((ref) => true);

  final ischeckBoxProvider = StateProvider<bool>((ref) => true);

  final usernameOrEmailController = TextEditingController();

  final passwordController = TextEditingController();
  final TokenCheckingState tokenCheckingState = Get.put(TokenCheckingState());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height45,
                //banner
                // BannerLogin(),
                height40,
                Center(
                  child: SizedBox(
                    height: 100,
                    width: 350,
                    child: Image.asset(
                      'assets/logo/view360_logo.jpeg',
                      fit: BoxFit.fitWidth,
                      //colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // SizedBox(height: 50),
                        //carosal widget
                        // CarosalWidget(page: "LOGINPAGE"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${'Welcome'.tr}! ",
                                    style: TextStyle(
                                      color: AppStyle.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                                  ),
                                  TransalatorIcon(),
                                ],
                              ),
                              height15,
                              Container(
                                decoration: BoxDecoration(
                                  //  color: AppStyle.white2,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: TextFormField(
                                  controller: usernameOrEmailController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter your username or email'.tr
                                      : null,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    prefixIcon: Icon(
                                      CupertinoIcons.person,
                                      size: 21,
                                      color: AppStyle.primary,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppStyle.black,
                                        width: .3, // Set border thickness here
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppStyle.primary,
                                        width: .3, // Set border thickness here
                                      ),
                                    ),
                                    hintText: 'Username or Email'.tr,
                                    hintStyle: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              height15,

                              //password form
                              Consumer(
                                builder: (context, ref, child) {
                                  final isObscure = ref.watch(
                                    isObscureProvider,
                                  );
                                  return Container(
                                    decoration: BoxDecoration(
                                      // color: AppStyle.white2,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your password'.tr
                                          : null,
                                      obscureText: isObscure,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12),
                                        prefixIcon: Icon(
                                          CupertinoIcons.lock,
                                          size: 21,
                                          color: AppStyle.primary,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            ref
                                                    .read(
                                                      isObscureProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                !isObscure;
                                          },
                                          icon: Icon(
                                            isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        hintText: 'Enter your password'.tr,
                                        hintStyle: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              height15,

                              //forgot password & remember me...
                              ForhotPasswordAndRememberMe(
                                ischeckBoxProvider: ischeckBoxProvider,
                              ),
                              height15,

                              //login button
                              Row(
                                children: [
                                  Flexible(
                                    child: Consumer(
                                      builder: (context, ref, child) => Center(
                                        child: SizedBox(
                                          height: 55,
                                          width: double.infinity,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors:
                                                    AppStyle.blueButtonGradient,
                                              ),
                                              // border: Border.all(
                                              //   color: AppStyle.primary,
                                              // ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Obx(
                                              () => ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          60,
                                                        ),
                                                  ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      const Color.fromARGB(
                                                        0,
                                                        73,
                                                        71,
                                                        71,
                                                      ),
                                                ),
                                                onPressed: () async {
                                                  final prefs =
                                                      await SharedPreferences.getInstance();
                                                  ref.invalidate(
                                                    auctionResponseProvider,
                                                  );
                                                  _submit(context);
                                                  final isChecked = ref.watch(
                                                    ischeckBoxProvider,
                                                  );
                                                  if (isChecked) {
                                                    //saving username and password for fingerprint
                                                    prefs.setString(
                                                      'username',
                                                      usernameOrEmailController
                                                          .text,
                                                    );
                                                    prefs.setString(
                                                      'password',
                                                      passwordController.text,
                                                    );
                                                  }
                                                },
                                                child: loginApi.isLoading.value
                                                    ? Center(
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 1,
                                                                color: white,
                                                              ),
                                                        ),
                                                      )
                                                    : Text(
                                                        'Login'.tr,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: AppStyle.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  PhoneNumberLogin(),
                                ],
                              ),

                              //continue as a phone number
                              height15,

                              height15,

                              //fingerprint login
                              FingerPrintLogin(loginApi: loginApi),
                              height15,

                              //Signup
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       'Don’t have an account?'.tr,
                              //       style: TextStyle(
                              //         color: AppStyle.secondColor,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // height10,

                              // //regsiter
                              // Row(
                              //   children: [
                              //     SizedBox(
                              //       height: 40,
                              //       width: 250,
                              //       child: ElevatedButton.icon(
                              //         label: Text(
                              //           'Register'.tr,
                              //           style: whiteStyle,
                              //         ),
                              //         style: ButtonStyle(
                              //           shape: WidgetStatePropertyAll(
                              //             RoundedRectangleBorder(
                              //               borderRadius:
                              //                   BorderRadius.circular(55),
                              //             ),
                              //           ),
                              //           backgroundColor:
                              //               WidgetStateProperty.all(
                              //                 AppStyle.secondary,
                              //               ),
                              //         ),
                              //         onPressed: () async {
                              //           SharedPreferences pref =
                              //               await SharedPreferences.getInstance();
                              //           final token = pref.getString('token');

                              //           Get.to(() {
                              //             return SignUpPage();
                              //             // return RegistrationScreen(
                              //             //   token: token ?? '',
                              //             //   //0 means from loginpage it navigating to registration page
                              //             //   checkPageID: 0,
                              //             // );
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     GuestLogin(),
                              //   ],
                              // ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Get.to(() => SignUpPage());
                              //   },
                              //   child: const Text('Sign Up'),
                              // ),

                              // height10,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      print(loginApi.success.value);
      try {
        final deviceName = await getDeviceName();
        final model = LoginModel(
          login: usernameOrEmailController.text,
          password: passwordController.text,
          device_name: deviceName,
        );

        print(model.toJson());
        // Call the login API
        await loginApi.login(model);
        tokenCheckingState.checkToken();
        // Handle the API response
        if (loginApi.success.value == true) {
          if (context.mounted) {
            SnackbarHelperTop.showSnackBar(
              context,
              'Welcome Back'.tr,
              color: Colors.green,
            );
          }

          Get.to(() => BottomNav());
        } else {
          Get.snackbar(
            'Something went wrong'.tr,
            loginApi.message.value,
            backgroundColor: Colors.red,
            colorText: white,
          );
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarHelper.showSnackBar(
            context,
            'An error occurred. Please try again.'.tr,
            color: Colors.red,
          );
        }
        debugPrint('Login Error: $e');
      }
    }
  }
}
