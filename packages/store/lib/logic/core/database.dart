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

  /// Initializes the database.
  @override
  @protected
  Future<bool> init() async {
    if (!isInitialized) {
      String? path;

      if (!kIsWeb) {
        path = Directory.current.path;
      }

      Hive.init(path);
      isInitialized = true;
    }

    return isInitialized;
  }
}
