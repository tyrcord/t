// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tstore/tstore.dart';
import '../../mocks/entities/person.entity.dart';

void main() {
  setUpTStoreTesting();

  group('Store', () {
    late PersonEntity person;
    late TStore store;

    setUp(() {
      store = TStore('persons');
      person = const PersonEntity(
        firstname: 'foo',
        lastname: 'bar',
        age: 42,
      );
    });

    group('#count', () {
      test('should return the number of persisted entries', () async {
        await store.connect();
        await store.clear();

        expect(store.count, equals(0));

        await store.persist('1', person.toJson());
        expect(store.count, equals(1));
      });
    });

    group('#connect()', () {
      test('should etablish a connection to the DB', () async {
        final isConnectionEtablished = await store.connect();
        expect(isConnectionEtablished, equals(true));
      });
    });

    group('#disconnect()', () {
      test('should disconnect from the DB', () async {
        final isConnectionEtablished = await store.connect();
        expect(isConnectionEtablished, equals(true));

        final isDisconnected = await store.connect();
        expect(isDisconnected, equals(true));
      });
    });

    group('#persist()', () {
      test('should persist a new entry', () async {
        await store.connect();
        await store.clear();

        await store.persist('1', person.toJson());
        var json = await store.retrieveEntity('1');
        expect(person, equals(PersonEntity.fromJson(json!)));
      });

      test('should update a persisted entry', () async {
        await store.connect();
        await store.clear();

        await store.persist('1', person.toJson());
        await store.persist('1', person.copyWith(age: 100).toJson());
        var json = await store.retrieveEntity('1');
        expect(PersonEntity.fromJson(json!).age, equals(100));
      });
    });

    group('#persistEntity()', () {
      test('should persist a new entity', () async {
        await store.connect();
        await store.clear();

        await store.persistEntity('1', person);
        var json = await store.retrieveEntity('1');
        expect(person, equals(PersonEntity.fromJson(json!)));
      });

      test('should update a persisted entity', () async {
        await store.connect();
        await store.clear();
        await store.persistEntity('1', person);
        await store.persistEntity('1', person.copyWith(age: 100));
        var json = await store.retrieveEntity('1');
        expect(PersonEntity.fromJson(json!).age, equals(100));
      });
    });

    group('#persist()', () {
      test('should retrieve a persisted entry', () async {
        await store.connect();
        await store.clear();
        await store.persist('1', person.toJson());
        var json = await store.retrieve('1') as Map<String, dynamic>;
        expect(person, equals(PersonEntity.fromJson(json)));
      });
    });

    group('#persistEntity()', () {
      test('should retrieve a persisted entity', () async {
        await store.connect();
        await store.clear();

        await store.persistEntity('1', person);
        var json = await store.retrieveEntity('1');
        expect(person, equals(PersonEntity.fromJson(json!)));
      });
    });

    group('#delete()', () {
      test('should delete a persisted entry', () async {
        await store.connect();
        await store.clear();

        await store.persist('1', person.toJson());
        await store.delete('1');
        var json = await store.retrieveEntity('1');

        expect(json, equals(null));
      });
    });

    group('#clear()', () {
      test('should delete all persisted entries', () async {
        await store.connect();
        await store.clear();

        await store.persist('1', person.toJson());
        await store.persist('2', person.toJson());
        await store.clear();

        var json = await store.retrieveEntity('1');
        var json2 = await store.retrieveEntity('2');

        expect(json, equals(null));
        expect(json2, equals(null));
      });
    });

    group('#list()', () {
      test('should list all persisted entries', () async {
        await store.connect();
        await store.clear();

        await store.persist('1', person.toJson());
        await store.persist('2', person.toJson());

        final list = await store.list<Map<String, dynamic>>();

        expect(list.length, equals(2));
        expect(person, equals(PersonEntity.fromJson(list[0])));
        expect(person, equals(PersonEntity.fromJson(list[1])));
      });
    });

    group('#toMap()', () {
      test('should list all persisted entries as a Map', () async {
        await store.connect();
        await store.clear();

        await store.persist('1', person.toJson());
        await store.persist('2', person.toJson());

        final map = await store.toMap<Map<String, dynamic>>();

        expect(map.length, equals(2));
        expect(person, equals(PersonEntity.fromJson(map['1']!)));
        expect(person, equals(PersonEntity.fromJson(map['2']!)));
      });
    });

    group('#find()', () {
      test(
        'should find some entries according to the finder function',
        () async {
          await store.connect();
          await store.clear();

          var candidates = await store.find((item) {
            var personEntity = PersonEntity.fromJson(Map<String, dynamic>.from(
              item as Map<dynamic, dynamic>,
            ));

            return personEntity.age == 42;
          });

          expect(candidates.length, equals(0));

          await store.persist('1', person.toJson());
          await store.persist('2', person.copyWith(age: 10).toJson());

          candidates = await store.find((item) {
            var personEntity = PersonEntity.fromJson(Map<String, dynamic>.from(
              item as Map<dynamic, dynamic>,
            ));

            return personEntity.age == 42;
          });

          expect(candidates.length, equals(1));
          expect(
            person,
            equals(
              PersonEntity.fromJson(
                Map<String, dynamic>.from(
                  candidates.first as Map<String, dynamic>,
                ),
              ),
            ),
          );
        },
      );
    });

    group('#findEntity()', () {
      test(
        'should find some entities according to the finder function',
        () async {
          await store.connect();
          await store.clear();

          var candidates = await store.findEntity((item) {
            var personEntity = PersonEntity.fromJson(item);

            return personEntity.age == 42;
          });

          expect(candidates.length, equals(0));

          await store.persist('1', person.toJson());
          await store.persist('2', person.copyWith(age: 10).toJson());

          candidates = await store.findEntity((item) {
            var personEntity = PersonEntity.fromJson(item);

            return personEntity.age == 42;
          });

          expect(candidates.length, equals(1));
          expect(person, equals(PersonEntity.fromJson(candidates.first)));
        },
      );
    });
  });
}
