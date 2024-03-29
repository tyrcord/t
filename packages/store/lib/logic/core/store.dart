// Dart imports:
import 'dart:async';

// Package imports:
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:tstore/tstore.dart';

class TStore {
  final _changesController = PublishSubject<TStoreChanges>();
  final String storeName;

  Future<bool>? _disconnectingFuture;
  Future<bool>? _connectingFuture;
  Box<dynamic>? _box;

  bool get isConnected => _box != null;
  bool get isConnecting => _connectingFuture != null;

  Stream<TStoreChanges> get onChanges => _changesController.stream;

  int get count {
    if (_box != null) return _box!.length;

    return 0;
  }

  TStore(this.storeName);

  Future<bool> connect() async {
    if (_disconnectingFuture != null) {
      await _disconnectingFuture;
    }

    if (_box == null && _connectingFuture == null) {
      final completer = Completer<bool>();
      _connectingFuture = completer.future;

      try {
        _box = await retry(task: () => Hive.openBox(storeName));
        _connectingFuture = null;
        completer.complete(true);
      } catch (error) {
        _box = null;
        _connectingFuture = null;
        completer.complete(false);
      }
    }

    if (_connectingFuture != null) return _connectingFuture!;

    return _box != null ? true : false;
  }

  Future<bool> disconnect() async {
    if (_connectingFuture != null) {
      await _connectingFuture;
    }

    if (_box != null && _disconnectingFuture == null) {
      final completer = Completer<bool>();
      _disconnectingFuture = completer.future;

      try {
        await _box!.close();
        _box = null;
        _disconnectingFuture = null;
        completer.complete(true);
      } catch (error) {
        _box = null;
        _disconnectingFuture = null;
        completer.complete(false);
      }
    }

    if (_disconnectingFuture != null) {
      return _disconnectingFuture!;
    }

    return _box == null ? true : false;
  }

  Future<dynamic> retrieve(String key) async {
    assert(_box != null, 'the store is not connected');

    return _box!.get(key);
  }

  Future<Map<String, dynamic>?> retrieveEntity(String key) async {
    assert(_box != null, 'the store is not connected');

    return _box!.get(key) as Map<String, dynamic>?;
  }

  Future<void> persist(String key, dynamic value) async {
    assert(_box != null, 'the store is not connected');

    final update = _box!.containsKey(key);
    await _box!.put(key, value);

    _notifyChangesListeners(
      update ? TStoreChangeType.update : TStoreChangeType.add,
      key: key,
      value: value,
    );
  }

  Future<void> persistAll(Map<String, dynamic> map) async {
    for (final element in map.entries) {
      await persist(element.key, element.value);
    }
  }

  Future<void> persistEntity(String key, TEntity entity) async {
    return persist(key, entity.toJson());
  }

  Future<void> delete(String key) async {
    assert(_box != null, 'the store is not connected');

    await _box!.delete(key);

    _notifyChangesListeners(TStoreChangeType.delete, key: key);
  }

  Future<void> deleteAll(Iterable<String> keys) async {
    assert(_box != null, 'the store is not connected');

    await _box!.deleteAll(keys);

    _notifyChangesListeners(TStoreChangeType.delete, keys: keys);
  }

  Future<void> clear() async {
    assert(_box != null, 'the store is not connected');

    await _box!.deleteAll(_box!.keys);

    _notifyChangesListeners(TStoreChangeType.deleteAll);
  }

  Future<List<V>> list<V>() async {
    final map = await toMap<V>();

    return map.values.toList();
  }

  Future<List<String>> listKeys() async {
    final map = await toMap();

    return map.keys.toList();
  }

  Future<List<dynamic>> find(bool Function(dynamic) finder) async {
    assert(_box != null, 'the store is not connected');

    final list = _box!.values.where(finder);

    return list.toList();
  }

  Future<List<Map<String, dynamic>>> findEntity(
    bool Function(Map<String, dynamic>) finder,
  ) async {
    assert(_box != null, 'the store is not connected');

    final values = _box!.values;

    return values
        .map<Map<String, dynamic>>((dynamic value) {
          return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
        })
        .where(finder)
        .toList();
  }

  Future<Map<String, V>> toMap<V>() async {
    assert(_box != null, 'the store is not connected');

    return _box!.toMap().cast<String, V>();
  }

  Stream<BoxEvent>? watch({String? key}) => _box!.watch(key: key);

  void _notifyChangesListeners(
    TStoreChangeType type, {
    String? key,
    dynamic value,
    Iterable<String>? keys,
  }) {
    if (keys != null) {
      for (final key in keys) {
        _changesController.add(TStoreChanges(
          type: type,
          key: key,
        ));
      }
    } else {
      _changesController.add(TStoreChanges(
        type: type,
        key: key,
        value: value,
      ));
    }
  }
}
