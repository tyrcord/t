// Dart imports:
import 'package:tsub/tsub.dart' if (dart.library.io) 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import 'package:tstore/tstore.dart';

/// The database is the object that manages store objects.
class TDataBase extends TDataBaseCore {
  /// The singleton instance.
  static final TDataBase _singleton = TDataBase._();

  factory TDataBase() => _singleton;

  TDataBase._();

  String? get _path {
    if (!kIsWeb) return Directory.current.path;

    return null;
  }

  /// Initializes the database.
  @override
  @protected
  Future<bool> init() async {
    if (!isInitialized) {
      Hive.init(_path);
      isInitialized = true;
    }

    return isInitialized;
  }

  @override
  Future<bool> storeExists(String storeName) async {
    return Hive.boxExists(storeName, path: _path);
  }
}
