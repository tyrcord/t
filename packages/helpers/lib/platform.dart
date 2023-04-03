import 'package:flutter/foundation.dart';

import 'package:tsub/tsub.dart' if (dart.library.io) 'dart:io';

bool get isIOS => !kIsWeb && Platform.isIOS;
bool get isMacOS => !kIsWeb && Platform.isMacOS;
bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isWindows => !kIsWeb && Platform.isWindows;
bool get isLinux => !kIsWeb && Platform.isLinux;
bool get isFuchsia => !kIsWeb && Platform.isFuchsia;
bool get isWeb => kIsWeb;
