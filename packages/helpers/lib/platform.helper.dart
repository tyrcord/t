// Import the Flutter foundation package, which provides essential classes and
// functions for building Flutter apps.
import 'package:flutter/foundation.dart';

// Conditionally import the 'tsub.dart' package if 'dart.library.io'
// is available, otherwise import the 'dart:io' package.
// This is useful for conditional imports based on the platform the code
// is running on.
import 'package:tsub/tsub.dart' if (dart.library.io) 'dart:io';

// Check if the app is running on an iOS platform.
bool get isIOS => !kIsWeb && Platform.isIOS;

// Check if the app is running on a macOS platform.
bool get isMacOS => !kIsWeb && Platform.isMacOS;

// Check if the app is running on an Android platform.
bool get isAndroid => !kIsWeb && Platform.isAndroid;

// Check if the app is running on a Windows platform.
bool get isWindows => !kIsWeb && Platform.isWindows;

// Check if the app is running on a Linux platform.
bool get isLinux => !kIsWeb && Platform.isLinux;

// Check if the app is running on a Fuchsia platform.
bool get isFuchsia => !kIsWeb && Platform.isFuchsia;

// Check if the app is running on the web. 'kIsWeb' is a constant provided by
// the 'foundation.dart' package to determine if the app is compiled for
// the web.
bool get isWeb => kIsWeb;
