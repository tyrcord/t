// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:t_cache/t_cache.dart';

/// A cache manager for managing cached items of type [T].
///
/// It provides functionality to get, put, and delete cached items.
/// It also manages the size of the cache and cleans up expired items.
class TCacheManager<T> {
  /// Internal cache of items.
  final Map<String, TCacheItem<T>> _cache = {};

  /// The interval at which the cache should be cleaned.
  Duration _cleaningInterval;

  /// Timer for periodic cache cleaning.
  Timer? _cleaningTimer;

  /// The maximum size the cache can hold.
  final int _maxSize;

  /// Current number of items in the cache.
  int _currentSize = 0;

  /// A label to be used for debugging purposes.
  final String? debugLabel;

  /// Determines if the manager should log messages.
  final bool silent;

  /// Creates a new instance of [TCacheManager].
  ///
  /// - [cleaningInterval]: The interval at which the cache should be cleaned.
  ///   Defaults to 1 minute.
  /// - [maxSize]: The maximum number of items the cache can hold.
  /// Defaults to 100.
  /// - [debugLabel]: A label to be used for debugging purposes.
  TCacheManager({
    Duration? cleaningInterval,
    int? maxSize,
    this.silent = false,
    this.debugLabel,
  })  : _cleaningInterval = cleaningInterval ?? const Duration(minutes: 1),
        _maxSize = maxSize ?? 100;

  /// Disposes the cache manager, canceling any ongoing cleaning operations.
  void dispose() => _cleaningTimer?.cancel();

  /// Inserts an item into the cache.
  ///
  /// - [key]: The key to store the item against.
  /// - [value]: The item to be cached.
  /// - [ttl]: The time-to-live duration for the item. Defaults to 1 minutes.
  void put(String key, T value, {Duration ttl = const Duration(minutes: 1)}) {
    debugLog(
      'Putting item with key: $key',
      debugLabel: debugLabel,
      silent: silent,
    );

    if (_currentSize == _maxSize) {
      _evictLRU();
    }

    _cache[key] = TCacheItem(value, ttl);
    _currentSize++;
    _startCleaningIfNeeded(); // Start cleaning if first item is added
  }

  /// Retrieves an item from the cache using its key.
  ///
  /// Returns the item if present and not expired, otherwise returns `null`.
  T? get(String key) {
    debugLog(
      'Getting item with key: $key',
      debugLabel: debugLabel,
      silent: silent,
    );

    final item = _cache[key];

    if (item == null || item.isExpired) {
      if (item != null) {
        debugLog(
          'Item with key: $key is expired',
          debugLabel: debugLabel,
          silent: silent,
        );
        delete(key); // Delete item if expired
      } else {
        debugLog(
          'Item with key: $key not found',
          debugLabel: debugLabel,
          silent: silent,
        );
      }

      return null;
    }

    item.updateAccessTime(); // Update the last accessed time

    debugLog(
      'Item with key: $key found',
      debugLabel: debugLabel,
      silent: silent,
    );
    debugLog(
      'Item with key: $key has value: ${item.value}',
      debugLabel: debugLabel,
      silent: silent,
    );

    return item.value;
  }

  /// Deletes an item from the cache using its key.
  void delete(String key) {
    debugLog(
      'Deleting item with key: $key',
      debugLabel: debugLabel,
      silent: silent,
    );
    _cache.remove(key);

    if (_currentSize > 0) {
      _currentSize--;
      _stopCleaningIfNeeded();
    }
  }

  /// Deletes all expired items from the cache.
  void deleteExpired() {
    debugLog('Deleting expired items', debugLabel: debugLabel, silent: silent);
    _cache.removeWhere((key, item) => item.isExpired);

    if (kDebugMode) {
      final removedItem = _cache.length - _currentSize;

      debugLog(
        'Deleted ${removedItem.abs()} expired items',
        debugLabel: debugLabel,
        silent: silent,
      );
    }

    _currentSize = _cache.length;
    _stopCleaningIfNeeded();
  }

  /// Updates the cleaning interval for the cache.
  ///
  /// - [newInterval]: The new interval to set for cleaning the cache.
  void updateCleaningInterval(Duration newInterval) {
    debugLog(
      'Updating cleaning interval to: ${newInterval.inSeconds} seconds',
      debugLabel: debugLabel,
      silent: silent,
    );

    clear();
    _cleaningInterval = newInterval;
    _startCleaningIfNeeded();
  }

  /// Clears the cache.
  /// Cancels any ongoing cleaning operations.
  /// Resets the current size to 0.
  /// Resets the cache to an empty state.
  void clear() {
    _stopCleaningIfNeeded();
    _currentSize = 0;
    _cache.clear();
  }

  /// Starts the periodic cleaning of the cache.
  void _startCleaningIfNeeded() {
    if (_currentSize == 1) {
      debugLog(
        'Starting cleaning with interval',
        value: '${_cleaningInterval.inSeconds} seconds',
        debugLabel: debugLabel,
        silent: silent,
      );
      _cleaningTimer?.cancel();

      _cleaningTimer = Timer.periodic(_cleaningInterval, (timer) {
        deleteExpired();
      });
    }
  }

  /// Stop cleaning if last item is deleted
  void _stopCleaningIfNeeded() {
    if (_currentSize == 0) {
      debugLog('Stopping cleaning', debugLabel: debugLabel, silent: silent);

      _cleaningTimer?.cancel();
    }
  }

  /// Evicts the least recently used item from the cache.
  void _evictLRU() {
    DateTime oldestTime = DateTime.now();
    String? lruKey;

    for (final entry in _cache.entries) {
      if (entry.value.lastAccessTime.isBefore(oldestTime)) {
        oldestTime = entry.value.lastAccessTime;
        lruKey = entry.key;
      }
    }

    if (lruKey != null) {
      debugLog(
        'Evicting LRU item with key: $lruKey',
        debugLabel: debugLabel,
        silent: silent,
      );
      _cache.remove(lruKey);
    }
  }
}
