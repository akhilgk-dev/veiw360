import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';

Future<String> getDeviceName() async {
  final deviceInfo = DeviceInfoPlugin();

  if (GetPlatform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return '${androidInfo.manufacturer} ${androidInfo.model}';
  } else if (GetPlatform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.name ?? iosInfo.model ?? 'iOS Device';
  } else {
    return 'Unknown Device';
  }
}
