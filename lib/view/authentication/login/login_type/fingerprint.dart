import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/api/authentication/login/login_api.dart';
import 'package:view360/common/get_device_info/get_device_info.dart';
import 'package:view360/common/utils/helpers/snackbar.dart';
import 'package:view360/model/authentication/login/login_model.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/theme/colors.dart';
import '../../../../common/utils/helpers/shared_pref.dart';
import '../../fingerprint/fingerprint.dart';
import '../widgets/fingerprint_container.dart';

class FingerPrintLogin extends StatelessWidget {
  const FingerPrintLogin({super.key, required this.loginApi});

  final LoginApi loginApi;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          print('Fingerprint authentication initiated');
          LocalAuthApi.canAuthenticate().then((value) {
            print('Can authenticate: $value');
            if (value) {
              LocalAuthApi.authenticate('Authenticate'.tr).then((value) async {
                print('Authentication result: $value');
                if (value) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  print('SharedPreferences loaded');
                  final deviceName = await getDeviceName();

                  if (pref.containsKey('username') &&
                      pref.containsKey('password')) {
                    print('User credentials found in SharedPreferences');
                    final model = LoginModel(
                      login: pref.getString('username')!,
                      password: pref.getString('password')!,
                      device_name: deviceName,
                    );

                    try {
                      print('Calling login API');
                      await loginApi.login(model);

                      print('Login API success: ${loginApi.success.value}');
                      if (loginApi.success.value == true) {
                        SharedPrefsHelper.saveString('username', model.login);
                        SharedPrefsHelper.saveString(
                          'password',
                          model.password,
                        );

                        if (context.mounted) {
                          SnackbarHelperTop.showSnackBar(
                            context,
                            'Login Successful'.tr,
                            color: Colors.green,
                          );
                        }

                        print('Navigating to BottomNav');
                        Get.to(() => BottomNav());
                      } else {
                        print('Login API failed: ${loginApi.message.value}');
                        Get.snackbar(
                          'Something went wrong'.tr,
                          loginApi.message.value,
                          backgroundColor: Colors.red,
                          colorText: white,
                        );
                      }
                    } catch (e) {
                      print('Login Error: $e');
                      if (context.mounted) {
                        SnackbarHelper.showSnackBar(
                          context,
                          'An error occurred. Please try again.'.tr,
                          color: Colors.red,
                        );
                      }
                    }
                  } else {
                    print('No user credentials found in SharedPreferences');
                    if (context.mounted) {
                      SnackbarHelper.showSnackBar(
                        context,
                        'No user found, Please Login/Register at one time'.tr,
                        color: Colors.red,
                      );
                    }
                  }
                } else {
                  print('Authentication failed');
                  SnackbarHelper.showSnackBar(
                    context,
                    'Authentication failed'.tr,
                    color: Colors.red,
                  );
                }
              });
            } else {
              print('Biometric authentication is not available');
              SnackbarHelper.showSnackBar(
                context,
                'Biometric authentication is not available'.tr,
                color: Colors.red,
              );
            }
          });
        },
        //fingerprint
        child: FingerprintContainerWidget(),
      ),
    );
  }
}
