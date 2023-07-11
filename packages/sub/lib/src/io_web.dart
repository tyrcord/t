// Flutter imports:
import 'package:flutter/foundation.dart';

// Dummy Platform class for the web
class Platform {
  static bool get isWeb => kIsWeb;
  static bool get isIOS => !kIsWeb;
  static bool get isMacOS => !kIsWeb;
  static bool get isAndroid => !kIsWeb;
  static bool get isWindows => !kIsWeb;
  static bool get isLinux => !kIsWeb;
  static bool get isFuchsia => !kIsWeb;
}

class Directory {
  static Directory current = Directory();

  String path = '';
}
