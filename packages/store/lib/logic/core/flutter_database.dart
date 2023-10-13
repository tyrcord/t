// Dart imports:
import 'dart:io';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'package:tstore/tstore.dart';

/// The database is the object that manages store objects.
/// This is the Flutter implementation.
class TFlutterDataBase extends TDataBaseCore {
  static final TFlutterDataBase _singleton = TFlutterDataBase._();

  /// The singleton instance.
  factory TFlutterDataBase() => _singleton;

  TFlutterDataBase._();

  /// Initializes the database.
  @override
  Future<bool> init() async {
    if (!isInitialized) {
      if (!isTest) {
        await Hive.initFlutter();
      }

      isInitialized = true;
    }

    return isInitialized;
  }

  bool get isTest {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  Future<bool> storeExists(String storeName) async {
    return Hive.boxExists(storeName);
  }
}
