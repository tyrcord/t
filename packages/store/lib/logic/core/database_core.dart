// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:tstore/tstore.dart';

/// The database is the object that manages store objects.
abstract class TDataBaseCore {
  static const activeStoresRegistryName = "tActiveStoresRegistry";

  /// The stores.
  @protected
  final Map<String, TStore> stores = {};

  /// The registers.
  /// A register is an object that is connected to a store.
  /// When the last register is disconnected, the store is disconnected.
  /// This is used to avoid unnecessary connections.
  @protected
  final Map<String, Set<Object>> registers = {};

  /// Indicates if the database is initialized.
  bool isInitialized = false;

  bool isRegisterConnected(String storeName, Object register) {
    if (isInitialized && registers.containsKey(storeName)) {
      return registers[storeName]!.contains(register);
    }

    return false;
  }

  bool isStoreConnected(String storeName) {
    if (isInitialized && stores.containsKey(storeName)) {
      return stores[storeName]!.isConnected;
    }

    return false;
  }

  @protected
  Future<void> updateActiveStoresRegistry(String storeName) async {
    final storesRegistry = await getStore(activeStoresRegistryName);
    await connect(activeStoresRegistryName, this);
    await storesRegistry.persist(storeName, true);
  }

  Future<List<String>> listActiveStores() async {
    final storesRegistry = await getStore(activeStoresRegistryName);
    await connect(activeStoresRegistryName, this);

    return storesRegistry.listKeys();
  }

  Future<void> clearActiveStores() async {
    final activeStoreKeys = await listActiveStores();

    for (final key in activeStoreKeys) {
      if (key != activeStoresRegistryName) {
        final store = await getStore(key);
        await store.connect();
        await store.clear();
      }
    }
  }

  /// Returns the store.
  Future<TStore> getStore(String storeName) async {
    await init();

    if (!stores.containsKey(storeName)) {
      stores.putIfAbsent(storeName, () => TStore(storeName));
      await updateActiveStoresRegistry(storeName);
    }

    return stores[storeName]!;
  }

  /// Connect
  Future<bool> connect(String storeName, Object register) async {
    final store = await getStore(storeName);
    registers.putIfAbsent(storeName, () => {});

    if (!isRegisterConnected(storeName, register)) {
      registers[storeName]!.add(register);
    }

    if (!store.isConnected) return store.connect();

    return store.isConnected;
  }

  /// Disconnect
  Future<bool> disconnect(String storeName, Object register) async {
    if (isInitialized) {
      final store = await getStore(storeName);

      if (store.isConnected && registers.containsKey(storeName)) {
        registers[storeName]!.remove(register);

        if (registers[storeName]!.isEmpty) {
          return store.disconnect();
        }
      }

      return true;
    }

    return false;
  }

  Future<bool> disconnectAll(String storeName) async {
    if (isInitialized) {
      final store = await getStore(storeName);

      if (store.isConnected && registers.containsKey(storeName)) {
        registers[storeName]!.clear();

        return store.disconnect();
      }

      return true;
    }

    return false;
  }

  /// Initializes the database.
  @protected
  Future<bool> init();

  Future<bool> storeExists(String storeName);
}
