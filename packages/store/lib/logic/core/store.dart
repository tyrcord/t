// Dart imports:
import 'dart:async';

// Package imports:
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:tstore/tstore.dart';

class TStore {
  static Future<bool>? _disconnectingFuture;
  static Future<bool>? _connectingFuture;
  static Future<Box>? _boxFuture;

  final _changesController = PublishSubject<TStoreChanges>();
  final String key;
  Box<dynamic>? _box;

  Stream<TStoreChanges> get onChanges => _changesController.stream;

  int get count => _box!.length;

  TStore(this.key);

  Future<bool> connect() async {
    if (_box == null && _boxFuture == null) {
      final completer = Completer<bool>();
      _connectingFuture = completer.future;

      if (_disconnectingFuture != null) {
        await _disconnectingFuture;
      }

      try {
        _boxFuture = Hive.openBox(key);
        _box = await _boxFuture;
        completer.complete(true);
      } catch (error) {
        completer.complete(false);
      } finally {
        _boxFuture = null;
      }
    }

    return _connectingFuture!;
  }

  Future<bool> disconnect() async {
    if (_disconnectingFuture == null) {
      final completer = Completer<bool>();
      _disconnectingFuture = completer.future;

      if (_connectingFuture != null) {
        await _connectingFuture;
      }

      try {
        if (_boxFuture != null) {
          await _boxFuture;
        }

        if (_box != null) {
          await _box!.close();
        }

        completer.complete(true);
      } catch (error) {
        completer.complete(false);
      } finally {
        _boxFuture = null;
        _box = null;
      }
    }

    return _disconnectingFuture!;
  }

  Future<dynamic> retrieve(String key) async => _box!.get(key);

  Future<Map<String, dynamic>?> retrieveEntity(String key) async {
    return _box!.get(key) as Map<String, dynamic>?;
  }

  Future<void> persist(String key, dynamic value) async {
    final update = _box!.containsKey(key);
    await _box!.put(key, value);

    _notifyChangesListeners(
      update ? TStoreChangeType.update : TStoreChangeType.add,
      key: key,
      value: value,
    );
  }

  Future<void> persistEntity(String key, TEntity entity) async {
    return persist(key, entity.toJson());
  }

  Future<void> delete(String key) async {
    await _box!.delete(key);

    _notifyChangesListeners(TStoreChangeType.delete, key: key);
  }

  Future<void> clear() async {
    await _box!.deleteAll(_box!.keys);

    _notifyChangesListeners(TStoreChangeType.deleteAll);
  }

  Future<List<V>> list<V>() async {
    final map = await toMap<V>();

    return map.values.toList();
  }

  Future<List<dynamic>> find(bool Function(dynamic) finder) async {
    final list = _box!.values.where(finder);

    return list.toList();
  }

  Future<List<Map<String, dynamic>>> findEntity(
    bool Function(Map<String, dynamic>) finder,
  ) async {
    final values = _box!.values;

    return values
        .map<Map<String, dynamic>>((dynamic value) {
          return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
        })
        .where(finder)
        .toList();
  }

  Future<Map<String, V>> toMap<V>() async => _box!.toMap().cast<String, V>();

  Stream<BoxEvent>? watch({String? key}) => _box!.watch(key: key);

  void _notifyChangesListeners(
    TStoreChangeType type, {
    String? key,
    dynamic value,
  }) {
    _changesController.add(TStoreChanges(
      type: type,
      key: key,
      value: value,
    ));
  }
}
