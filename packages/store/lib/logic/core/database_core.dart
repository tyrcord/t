// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:tstore/tstore.dart';

/// The database is the object that manages store objects.
abstract class TDataBaseCore {
  /// The stores.
  @protected
  final Map<String, TStore> stores = {};

  /// Indicates if the database is initialized.
  @protected
  bool isInitialized = false;

  /// Returns the store.
  Future<TStore> getStore(String name) async {
    await init();

    if (!stores.containsKey(name)) {
      stores.putIfAbsent(name, () => TStore(name));
    }

    return stores[name]!;
  }

  /// Initializes the database.
  @protected
  Future<bool> init();
}
