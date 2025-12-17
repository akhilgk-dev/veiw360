import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> whatsapp() async {
  String contact =
      "+96894370339"; // Ensure international format with country code
  String text = 'Hello, I am interested in this auction';
  String nativeUrl =
      "whatsapp://send?phone=$contact&text=${Uri.encodeComponent(text)}";
  String webUrl =
      "https://api.whatsapp.com/send?phone=$contact&text=${Uri.encodeComponent(text)}";

  try {
    // Try launching the native WhatsApp app (works for both iOS and Android)
    if (await canLaunchUrl(Uri.parse(nativeUrl))) {
      await launchUrl(
        Uri.parse(nativeUrl),
        mode: LaunchMode.platformDefault, // Default mode for native app
      );
    } else {
      // Fallback to web URL if WhatsApp app is not installed
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode:
              LaunchMode.externalApplication, // Open in browser or external app
        );
      } else {
        throw 'Could not launch WhatsApp';
      }
    }
  } catch (e) {
    print('Error launching WhatsApp: $e');
    // Optionally, show a user-friendly message (e.g., SnackBar or Dialog)
    // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open WhatsApp')));
  }
}

Future<void> playstore() async {
  String playstoreUrl =
      "https://play.google.com/store/apps/details?id=com.mzadcom.mzadcom&hl=en";

  try {
    if (await canLaunchUrl(Uri.parse(playstoreUrl))) {
      await launchUrl(
        Uri.parse(playstoreUrl),
        mode: LaunchMode.externalApplication, // Open in browser or external app
      );
    } else {
      throw 'Could not launch Play Store';
    }
  } catch (e) {
    print('Error launching Play Store: $e');
    // Optionally, show a user-friendly message (e.g., SnackBar or Dialog)
    // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open Play Store')));
  }
}

Future<void> appstore() async {
  String appStoreUrl = "https://apps.apple.com/om/app/mzadcom/id6754008508";

  try {
    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(
        Uri.parse(appStoreUrl),
        mode: LaunchMode.externalApplication, // Open in browser or external app
      );
    } else {
      throw 'Could not launch App Store';
    }
  } catch (e) {
    debugPrint('Error launching App Store: $e');
    // Optionally, show a user-friendly message (e.g., SnackBar or Dialog)
    // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to open Play Store')));
  }
}
