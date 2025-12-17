import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view360/common/theme/style.dart';
import 'package:view360/view/auction_details/url_launcher/whatsapp.dart';

import '../../../common/theme/colors.dart';
import '../../../common/theme/sized_box.dart';
import 'make_phone_call.dart';

class UrlLauncherWhatsappAndPhoneButton extends StatelessWidget {
  const UrlLauncherWhatsappAndPhoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(lightGrey),
                shape: WidgetStateProperty.all(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                makePhoneCall('94370339');
              },
              label: Text('Call'.tr, style: blackStyle),
              icon: Icon(Icons.call, color: black),
            ),
          ),
          width05,

          //whatsapp button
          Expanded(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                shape: WidgetStateProperty.all(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                whatsapp();
              },
              label: Text('Whatsapp'.tr, style: whiteStyle),
              icon: Image.asset(
                'assets/bottomNavIcon/download.png',
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
