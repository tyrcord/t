//ignore_for_file: no-empty-block

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:subx/subx.dart';

void main() {
  group('SubxMap', () {
    late SubxMap subxMap;
    late BehaviorSubject source;
    late StreamSubscription subscription;
    late StreamSubscription subscription2;

    setUp(() {
      subxMap = SubxMap();
      source = BehaviorSubject();
      subscription = source.listen((data) {});
      subscription2 = source.listen((data) {});
    });

    tearDown(() {
      subxMap.cancelAll();
      source.close();
    });

    group('#length', () {
      test('should return the number of tracked subscriptions', () {
        expect(subxMap.length, equals(0));
        subxMap.add('key', subscription);
        expect(subxMap.length, equals(1));
      });
    });

    group('#add()', () {
      test('should add a subscription to the list', () {
        expect(subxMap.length, equals(0));
        subxMap.add('key', subscription);
        expect(subxMap.length, equals(1));
      });

      test(
        'should replace a subscription from the list and '
        'cancel it when the key already exist',
        () {
          subxMap.add('key', subscription);
          expect(subxMap.length, equals(1));

          subxMap.add('key', subscription2);
          expect(subxMap.length, equals(1));
        },
      );

      test(
        'should not cancel a subscription when '
        'the same subscription is added with the same key',
        () {
          subxMap.add('key', subscription);
          expect(subxMap.length, equals(1));

          subxMap.add('key', subscription);
          expect(subxMap.length, equals(1));
        },
      );

      test('should allow chaining calls', () {
        expect(subxMap.length, equals(0));
        subxMap
          ..add('key', subscription)
          ..add('key2', subscription2);
        expect(subxMap.length, equals(2));
      });
    });

    group('#operator [](int index)', () {
      test('should return a subscription from the list with an index', () {
        subxMap.add('key', subscription);
        expect(subxMap['key'], equals(subscription));
      });
    });

    group('#containsSubscription()', () {
      test('should return true if this list contains the given subscription',
          () {
        subxMap.add('key', subscription);
        expect(subxMap.containsSubscription(subscription), equals(true));
      });

      test(
        'should return false if this list '
        'does not contain the given subscription',
        () {
          expect(subxMap.containsSubscription(subscription), equals(false));
        },
      );
    });

    group('#cancelAt()', () {
      test('should cancel a subscription with an index', () async {
        subxMap
          ..add('key', subscription)
          ..add('key2', subscription2);
        expect(subxMap.length, equals(2));

        final unsubscribed = await subxMap.cancelForKey('key');

        expect(subxMap.length, equals(1));
        expect(unsubscribed, equals(true));
      });

      test('should handle wrong keys', () async {
        subxMap.add('key', subscription);
        expect(subxMap.length, equals(1));

        final unsubscribed = await subxMap.cancelForKey('key2');

        expect(subxMap.length, equals(1));
        expect(unsubscribed, equals(false));
      });
    });

    group('#cancelAll()', () {
      test('should cancel all subscriptions', () {
        subxMap
          ..add('key', subscription)
          ..add('key2', subscription2);
        expect(subxMap.length, equals(2));

        subxMap.cancelAll();

        expect(subxMap.length, equals(0));
      });
    });

    group('#pauseAll()', () {
      test('should pause all subscriptions', () {
        subxMap
          ..add('key', subscription)
          ..add('key2', subscription2);
        expect(subxMap.length, equals(2));

        subxMap.pauseAll();

        expect(subxMap['key']!.isPaused, true);
        expect(subxMap['key2']!.isPaused, true);
      });
    });

    group('#resumeAll()', () {
      test('should resume all subscriptions', () {
        subxMap
          ..add('key', subscription)
          ..add('key2', subscription2);
        expect(subxMap.length, equals(2));

        subxMap.pauseAll();

        expect(subxMap['key']!.isPaused, true);
        expect(subxMap['key2']!.isPaused, true);

        subxMap.resumeAll();

        expect(subxMap['key']!.isPaused, false);
        expect(subxMap['key2']!.isPaused, false);
      });
    });
  });
}
