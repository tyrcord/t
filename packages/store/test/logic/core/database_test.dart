// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tstore/tstore.dart';

void main() {
  group('DataBase', () {
    late TDataBase db;
    final registerObject = Object();
    const sampleStoreName = 'sampleStore';
    const sampleStoreName1 = 'sampleStore1';
    const sampleStoreName2 = 'sampleStore2';

    setUp(() {
      db = TDataBase();
    });

    tearDown(() async {
      await db.disconnectAll(sampleStoreName);
      await db.disconnectAll(sampleStoreName1);
      await db.disconnectAll(sampleStoreName2);
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
        final store = await db.getStore(sampleStoreName);
        expect(store, isA<TStore>());
      });

      test('should returns the same TStore object for the same store name',
          () async {
        final store1 = await db.getStore(sampleStoreName);
        final store2 = await db.getStore(sampleStoreName);
        expect(store1, equals(store2));
      });

      test('should creates a new TStore object for a different store name',
          () async {
        final store1 = await db.getStore(sampleStoreName1);
        final store2 = await db.getStore(sampleStoreName2);
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

    group('#updateActiveStoresRegistry()', () {
      test('should register new store in the active stores registry', () async {
        // This should internally call updateActiveStoresRegistry
        await db.getStore(sampleStoreName);

        final activeStores = await db.listActiveStores();
        expect(activeStores.contains(sampleStoreName), true);
      });

      test('should not create duplicate entries for the same store', () async {
        await db.getStore(sampleStoreName);
        // Call again to simulate duplicate registration
        await db.getStore(sampleStoreName);
        final activeStores = await db.listActiveStores();
        expect(activeStores.where((name) => name == sampleStoreName).length, 1);
      });
    });

    group('#clearActiveStoresRegistry()', () {
      test('should clear all stores and the registry', () async {
        final store1 = await db.getStore(sampleStoreName1);
        final store2 = await db.getStore(sampleStoreName2);

        await store1.connect();
        await store2.connect();

        await store1.persist('1', {'name': 'John'});
        await store2.persist('1', {'name': 'John'});
        await store1.persist('2', {'name': 'John'});

        var list1 = await store1.listKeys();
        var list2 = await store2.listKeys();

        expect(list1.length, 2);
        expect(list2.length, 1);

        await db.clearActiveStores();

        list1 = await store1.listKeys();
        list2 = await store2.listKeys();

        expect(list1.length, 0);
        expect(list2.length, 0);
      });
    });
  });
}
