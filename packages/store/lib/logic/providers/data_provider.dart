// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:tstore/tstore.dart';

/// A data provider is the object that manages the data persistence.
abstract class TDataProvider {
  /// Indicates if the data provider is connecting to the store.
  bool _isConnecting = false;

  /// Indicates if the data provider is connected to the store.
  bool _isConnected = false;

  /// Keeps track of the number of connections.
  int _connectionCount = 0;

  /// The store is the object that manages the data persistence.
  TStore? _store;

  /// The database is the object that manages the store.
  @protected
  final TDataBaseCore database = TFlutterDataBase();

  /// The name of the store.
  @protected
  final String storeName;

  /// Returns the store.
  @protected
  TStore get store {
    assert(_store != null, 'the method `connect` should be called first');

    return _store!;
  }

  /// Returns the stream of changes.
  Stream<TStoreChanges> get onChanges => store.onChanges;

  TDataProvider({required this.storeName});

  /// Initializes the data provider.
  Future<bool> connect() async {
    if (!_isConnecting && !_isConnected) {
      _isConnecting = true;
      _store = await database.getStore(storeName);
      _isConnected = await store.connect();
      _isConnecting = false;
    }

    _connectionCount++;

    return _isConnected;
  }

  /// Closes the data provider.
  Future<bool> disconnect() async {
    if (_isConnected && _connectionCount > 0) {
      _connectionCount--;

      // Only disconnect when connection count reaches zero
      if (_connectionCount == 0) {
        _isConnected = await store.disconnect();
      }
    }

    return _isConnected;
  }
}
