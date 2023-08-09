import 'dart:async';
import 'package:t_cache/t_cache.dart';

/// A cache manager for managing cached items of type [T].
///
/// It provides functionality to get, put, and delete cached items.
/// It also manages the size of the cache and cleans up expired items.
class TCacheManager<T> {
  /// Internal cache of items.
  final Map<String, TCacheItem<T>> _cache = {};

  /// The interval at which the cache should be cleaned.
  final Duration _cleaningInterval;

  /// Timer for periodic cache cleaning.
  Timer? _cleaningTimer;

  /// The maximum size the cache can hold.
  final int _maxSize;

  /// Current number of items in the cache.
  int _currentSize = 0;

  /// Creates a new instance of [TCacheManager].
  ///
  /// - [cleaningInterval]: The interval at which the cache should be cleaned.
  ///   Defaults to 1 minute.
  /// - [maxSize]: The maximum number of items the cache can hold. Defaults to 100.
  TCacheManager({
    Duration? cleaningInterval,
    int maxSize = 100,
  })  : _cleaningInterval = cleaningInterval ?? const Duration(minutes: 1),
        _maxSize = maxSize {
    _startCleaning();
  }

  /// Disposes the cache manager, canceling any ongoing cleaning operations.
  void dispose() => _cleaningTimer?.cancel();

  /// Inserts an item into the cache.
  ///
  /// - [key]: The key to store the item against.
  /// - [value]: The item to be cached.
  /// - [ttl]: The time-to-live duration for the item. Defaults to 10 minutes.
  void put(String key, T value, {Duration ttl = const Duration(minutes: 10)}) {
    if (_currentSize == _maxSize) {
      _evictLRU();
    }

    _cache[key] = TCacheItem(value, ttl);
    _currentSize++;
  }

  /// Retrieves an item from the cache using its key.
  ///
  /// Returns the item if present and not expired, otherwise returns `null`.
  T? get(String key) {
    final item = _cache[key];

    if (item == null || item.isExpired) {
      _cache.remove(key);
      if (_currentSize > 0) {
        _currentSize--;
      }

      return null;
    }

    item.updateAccessTime(); // Update the last accessed time

    return item.value;
  }

  /// Deletes an item from the cache using its key.
  void delete(String key) {
    _cache.remove(key);
    if (_currentSize > 0) {
      _currentSize--;
    }
  }

  /// Deletes all expired items from the cache.
  void deleteExpired() {
    _cache.removeWhere((key, item) => item.isExpired);
  }

  /// Starts the periodic cleaning of the cache.
  void _startCleaning() {
    _cleaningTimer?.cancel();

    _cleaningTimer = Timer.periodic(_cleaningInterval, (timer) {
      deleteExpired();
    });
  }

  /// Evicts the least recently used item from the cache.
  void _evictLRU() {
    String? lruKey;
    DateTime oldestTime = DateTime.now();

    for (final entry in _cache.entries) {
      if (entry.value.lastAccessTime.isBefore(oldestTime)) {
        oldestTime = entry.value.lastAccessTime;
        lruKey = entry.key;
      }
    }

    if (lruKey != null) {
      _cache.remove(lruKey);
    }
  }
}
