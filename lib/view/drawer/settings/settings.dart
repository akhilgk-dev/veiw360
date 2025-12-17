import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/auction_details/url_launcher/buttons_whatsapp_phone.dart';
import 'package:view360/view/dashboard/my_winnings/my_winnings.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({super.key});
  final reasonfordeleting = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> settings = [
      'Currency'.tr,
      'Privacy Policy'.tr,
      'Delete Account'.tr,
    ];
    return Scaffold(
      appBar: AppbarWidget(title: 'Settings'.tr),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            Column(
              children: List.generate(settings.length, (index) {
                return ListTile(
                  onTap: () {
                    if (index == 1) {
                      launchPDF(
                        "https://www.freeprivacypolicy.com/live/aa1bc263-426e-4e78-94e4-e34dc86f6a55",
                      );
                    }
                    if (index == 2) {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: darkBlue,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete Account'.tr, style: whiteStyle),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Deleting your account is irreversible.'.tr,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Please let us know the reason for deleting your account:'
                                    .tr,
                                style: whiteStyle,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                style: TextStyle(color: white),
                                controller: reasonfordeleting,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your reason here'.tr,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Cancel'.tr,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Add your delete account logic here

                                Get.snackbar(
                                  'Error'.tr,
                                  'Something went wrong.'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              },
                              child: Text(
                                'Delete'.tr,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  minTileHeight: 40,
                  title: Text(
                    settings[index],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  trailing: index == 0
                      ? Text('OMR'.tr)
                      : Icon(Icons.arrow_forward_ios, size: 14),
                );
              }),
            ),
            Spacer(),
            Text(
              'For any queries, please contact us at:'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            Divider(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: UrlLauncherWhatsappAndPhoneButton(),
      ),
    );
  }
}
