import 'package:flutter_test/flutter_test.dart';
import 'package:tstore/tstore.dart';

void main() {
  group('StoreChanges', () {
    late TStoreChanges storeChanges;
    late TStoreChanges storeChanges2;

    setUp(() {
      storeChanges = TStoreChanges(type: TStoreChangeType.delete, key: 'age');
      storeChanges2 = TStoreChanges(type: TStoreChangeType.delete, value: 42);
    });

    group('#clone()', () {
      test('should return a copy of a StoreChanges object', () {
        final copy = storeChanges.clone();

        expect(storeChanges == copy, equals(true));
        expect(copy.type, equals(TStoreChangeType.delete));
      });
    });

    group('#copyWith()', () {
      test('should return a copy of a StoreChanges object', () {
        final copy = storeChanges.copyWith(key: 'foo');

        expect(storeChanges == copy, equals(false));
        expect(copy.type, equals(TStoreChangeType.delete));
        expect(copy.key, equals('foo'));
      });
    });

    group('#merge()', () {
      test('should return a merge two StoreChanges objects', () {
        final copy = storeChanges.merge(storeChanges2);

        expect(storeChanges == copy, equals(false));
        expect(copy.type, equals(TStoreChangeType.delete));
        expect(copy.key, equals('age'));
        expect(copy.value, equals(42));
      });
    });
  });
}
