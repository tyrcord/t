import 'package:flutter_test/flutter_test.dart';
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
        ..delete('key1');

      expect(cacheManager.get('key1'), isNull);
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
  });
}
