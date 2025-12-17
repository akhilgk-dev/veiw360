// import 'package:url_launcher/url_launcher.dart';

// Future<void> makePhoneCall(String phoneNumber) async {
//   final Uri launchUri = Uri(
//     scheme: 'tel',
//     path: phoneNumber,
//   );
//   await launchUrl(launchUri);
// }


import 'package:url_launcher/url_launcher.dart';

/// Makes a phone call to the specified phone number.
Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  try {
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  } catch (e) {
    print('Error launching phone call: $e');
  }
}

