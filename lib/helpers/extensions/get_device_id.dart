import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';

class GetDeviceID {
  const GetDeviceID._();

  static Future<String?> getId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if(Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.fingerprint;
    } else {
      return List.generate(
        24, (_) => 
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[Random().nextInt(62)]
      ).join();
    }
  }
}