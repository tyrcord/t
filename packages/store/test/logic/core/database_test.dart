// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tstore/tstore.dart';

void main() {
  group('DataBase', () {
    late TDataBase db;
    final registerObject = Object();
    const sampleStoreName = 'sampleStore';

    setUp(() {
      db = TDataBase();
    });

    tearDown(() async {
      await db.disconnectAll(sampleStoreName);
    });

    group('#constructor()', () {
      test('should return a singleton', () {
        expect(db, isA<TDataBase>());
        expect(db, equals(TDataBase()));
      });

      // Test initial state
      test('DatabaseCore should not be initialized on creation', () {
        expect(db.isInitialized, false);
      });
    });

    group('#getStore()', () {
      test('should returns a TStore object', () async {
        final store = await db.getStore('test');
        expect(store, isA<TStore>());
      });

      test('should returns the same TStore object for the same store name',
          () async {
        final store1 = await db.getStore('test');
        final store2 = await db.getStore('test');
        expect(store1, equals(store2));
      });

      test('should creates a new TStore object for a different store name',
          () async {
        final store1 = await db.getStore('test1');
        final store2 = await db.getStore('test2');
        expect(store1, isNot(equals(store2)));
      });
    });

    group('#connect()', () {
      test('should register and connect to a store', () async {
        final isConnected = await db.connect(sampleStoreName, registerObject);
        expect(isConnected, true);
        expect(db.isRegisterConnected(sampleStoreName, registerObject), true);
      });
    });

    group('#disconnect()', () {
      test(
          'should deregister but not disconnect store if there are '
          'remaining registers', () async {
        await db.connect(sampleStoreName, registerObject);

        // adding a second register to the same store
        final secondRegisterObject = Object();
        await db.connect(sampleStoreName, secondRegisterObject);

        final hasDisconnected = await db.disconnect(
          sampleStoreName,
          registerObject,
        );

        expect(hasDisconnected, true);
        expect(db.isStoreConnected(sampleStoreName), true);
        expect(db.isRegisterConnected(sampleStoreName, registerObject), false);

        expect(
          db.isRegisterConnected(sampleStoreName, secondRegisterObject),
          true,
        );
      });

      test('should disconnect store if no registers are left', () async {
        await db.connect(sampleStoreName, registerObject);
        final isDisconnected = await db.disconnect(
          sampleStoreName,
          registerObject,
        );

        expect(isDisconnected, true);
        expect(db.isStoreConnected(sampleStoreName), false);
      });
    });
  });
}
