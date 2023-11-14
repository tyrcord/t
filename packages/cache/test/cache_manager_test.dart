// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_cache/t_cache.dart';

void main() {
  group('TCacheManager', () {
    late TCacheManager<String> cacheManager;

    setUp(() {
      cacheManager = TCacheManager<String>(maxSize: 3);
    });

    tearDown(() {
      cacheManager.dispose();
    });

    test('put and get', () {
      cacheManager.put('key', 'value');
      expect(cacheManager.get('key'), equals('value'));
    });

    test('put with TTL and get after expiration', () async {
      cacheManager.put('key', 'value', ttl: const Duration(seconds: 1));
      await Future.delayed(const Duration(seconds: 2));
      expect(cacheManager.get('key'), isNull);
    });

    test('put with TTL and get before expiration', () async {
      cacheManager.put('key', 'value', ttl: const Duration(seconds: 1));
      await Future.delayed(const Duration(milliseconds: 500));
      expect(cacheManager.get('key'), equals('value'));
    });

    test('put and delete', () {
      cacheManager
        ..put('key1', 'value1')
        ..put('key2', 'value2')
        ..delete('key1');

      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), equals('value2'));
    });

    test('put and evict LRU', () {
      cacheManager
        ..put('key1', 'value1')
        ..put('key2', 'value2')
        ..put('key3', 'value3')
        ..put('key4', 'value4');

      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), equals('value2'));
      expect(cacheManager.get('key3'), equals('value3'));
      expect(cacheManager.get('key4'), equals('value4'));
    });

    test('put and delete expired', () async {
      cacheManager
        ..put('key', 'value', ttl: const Duration(seconds: 1))
        ..put('key2', 'value2', ttl: const Duration(seconds: 1))
        ..put('key3', 'value3', ttl: const Duration(seconds: 1));

      await Future.delayed(const Duration(seconds: 2));

      expect(cacheManager.get('key'), isNull);
      expect(cacheManager.get('key2'), isNull);
      expect(cacheManager.get('key3'), isNull);
    });

    test('evict LRU', () {
      cacheManager
        ..put('key1', 'value1')
        ..put('key2', 'value2')
        ..get('key1')
        ..put('key3', 'value3')
        ..put('key4', 'value4');

      expect(cacheManager.get('key1'), equals('value1'));
      expect(cacheManager.get('key2'), isNull);
      expect(cacheManager.get('key3'), equals('value3'));
      expect(cacheManager.get('key4'), equals('value4'));
    });

    test('update cleaning interval', () async {
      // Setting up a cache manager with a specific cleaning interval
      cacheManager = TCacheManager<String>(
          cleaningInterval: const Duration(seconds: 2), maxSize: 3)
        ..put('key1', 'value1', ttl: const Duration(seconds: 1))
        ..put('key2', 'value2', ttl: const Duration(seconds: 1));

      // Wait for the original cleaning interval to pass
      await Future.delayed(const Duration(seconds: 3));

      // Items should be evicted by now due to the original cleaning interval
      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), isNull);

      // Updating the cleaning interval to a longer duration
      cacheManager
        ..updateCleaningInterval(const Duration(seconds: 5))
        ..put('key3', 'value3', ttl: const Duration(seconds: 4))
        ..put('key4', 'value4', ttl: const Duration(seconds: 4));

      // Wait for less than the updated cleaning interval
      await Future.delayed(const Duration(seconds: 3));

      // The items should still be present, as the cleaning interval
      // is longer now
      expect(cacheManager.get('key3'), equals('value3'));
      expect(cacheManager.get('key4'), equals('value4'));

      // Wait for the updated cleaning interval to pass
      await Future.delayed(const Duration(seconds: 3));

      // Items should be evicted by now due to the updated cleaning interval
      expect(cacheManager.get('key3'), isNull);
      expect(cacheManager.get('key4'), isNull);
    });

    test('reset cache on cleaning interval update', () async {
      // Initialize a cache manager with a short cleaning interval and a
      //small max size
      final cacheManager = TCacheManager<String>(
        cleaningInterval: const Duration(seconds: 2),
        maxSize: 3,
      )
        ..put('key1', 'value1')
        ..put('key2', 'value2');

      // Verify initial cache items are present
      expect(cacheManager.get('key1'), equals('value1'));
      expect(cacheManager.get('key2'), equals('value2'));

      // Update the cleaning interval
      cacheManager.updateCleaningInterval(const Duration(seconds: 5));

      // Check if the cache has been reset by verifying the absence of
      // previous items
      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), isNull);

      // Optionally, you can add new items to the cache and verify they are
      // stored correctly
      cacheManager
        ..put('key3', 'value3')
        ..put('key4', 'value4');

      expect(cacheManager.get('key3'), equals('value3'));
      expect(cacheManager.get('key4'), equals('value4'));
    });

    test('clear method removes all items and stops cleaning', () async {
      // Initialize a cache manager with a short cleaning interval
      final cacheManager = TCacheManager<String>(
        cleaningInterval: const Duration(seconds: 2),
        maxSize: 3,
      )
        ..put('key1', 'value1')
        ..put('key2', 'value2');

      // Confirm that items are in the cache
      expect(cacheManager.get('key1'), equals('value1'));
      expect(cacheManager.get('key2'), equals('value2'));

      // Clear the cache
      cacheManager.clear();

      // Check that the cache is empty
      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), isNull);
    });
  });
}
