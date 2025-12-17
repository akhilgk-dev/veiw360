import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/sized_box.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/authentication/registration/individual_formfield.dart';
import 'package:view360/view/authentication/registration/reg_without_token/indv.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';
import 'package:get/get.dart'; // Add this import for translations

import 'institution_formfield.dart';

// Riverpod provider to manage state
final registrationTypeProvider = StateProvider<bool>((ref) => true);

class RegistrationScreen extends ConsumerWidget {
  final String? token;
  final int checkPageID;
  const RegistrationScreen({super.key, required this.checkPageID, this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //profile details

    final isInstitution = ref.watch(registrationTypeProvider);

    return Scaffold(
      appBar: AppbarWidget(
        //checking which page come from showing terms and condition (0 means it is from Login page)
        title: checkPageID == 0 ? 'Registration'.tr : 'Edit Profile'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: AppStyle.primary.withAlpha(150),
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(10),
                    //       topRight: Radius.circular(10),
                    //     ),
                    //   ),
                    //   height: 70,
                    //   width: double.infinity,
                    //   child: Row(
                    //     children: [
                    //       width20,
                    //       Text(
                    //         checkPageID == 0 ? 'Signup - '.tr : 'Profile  -'.tr,
                    //         style: whiteStyle,
                    //       ),
                    //       width10,
                    //       Text(
                    //         isInstitution ? 'Institution'.tr : 'Individual'.tr,
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    height05,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //checking which page come from showing terms and condition (0 means it is from Login page)
                            checkPageID == 0
                                ? 'Registration type'.tr
                                : 'Edit profile type'.tr,
                            style: headingTextStyle17,
                          ),
                          height10,
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                          isInstitution
                                              ? AppStyle.secondColor
                                              : Colors.white,
                                        ),
                                    shape:
                                        WidgetStateProperty.all<
                                          RoundedRectangleBorder
                                        >(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                  ),
                                  onPressed: () =>
                                      ref
                                              .read(
                                                registrationTypeProvider
                                                    .notifier,
                                              )
                                              .state =
                                          true,
                                  label: Text(
                                    'Institution'.tr,
                                    style: TextStyle(
                                      color: isInstitution
                                          ? Colors.white
                                          : AppStyle.primary,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.business,
                                    color: isInstitution
                                        ? Colors.white
                                        : AppStyle.primary,
                                  ),
                                ),
                              ),
                              width05,
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                          isInstitution
                                              ? Colors.white
                                              : AppStyle.secondColor,
                                        ),
                                    shape:
                                        WidgetStateProperty.all<
                                          RoundedRectangleBorder
                                        >(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                  ),
                                  onPressed: () =>
                                      ref
                                              .read(
                                                registrationTypeProvider
                                                    .notifier,
                                              )
                                              .state =
                                          false,
                                  label: Text(
                                    'Individual'.tr,
                                    style: TextStyle(
                                      color: isInstitution
                                          ? AppStyle.primary
                                          : Colors.white,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.person,
                                    color: isInstitution
                                        ? AppStyle.primary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height20,
                          // Show respective form fields
                          isInstitution
                              ? InstitutionForm(checkPageId: checkPageID)
                              : token!.isEmpty
                              ? IndividualFormWithoutToken(
                                  checkPageID: checkPageID,
                                )
                              : IndividualForm(checkPageID: checkPageID),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
