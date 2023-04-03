import 'package:hive_flutter/hive_flutter.dart';

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
      await Hive.initFlutter();
      isInitialized = true;
    }

    return isInitialized;
  }
}
