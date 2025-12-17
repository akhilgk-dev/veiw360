import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

Future<void> instagrame({
  required String androidUrlValue,
  String? ios,
  String? webUrl,
}) async {
  String androidUrl = androidUrlValue;
  String iosUrl = androidUrlValue;
  String webUrl = androidUrlValue;

  try {
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(iosUrl))) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        throw 'Could not launch $iosUrl';
      }
    } else if (Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(androidUrl))) {
        await launchUrl(Uri.parse(androidUrl));
      } else {
        // Fallback to web URL if the app-specific URL fails
        if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(
            Uri.parse(webUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not launch $webUrl';
        }
      }
    } else {
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $webUrl';
      }
    }
  } catch (e) {
    print('Error launching WhatsApp: $e');
  }
}
