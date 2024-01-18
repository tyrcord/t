// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../../mocks/entities/person.entity.dart';

void main() {
  group('PersonEntity', () {
    test('fromJson and toJson', () {
      final personJson = {
        'firstName': 'John',
        'lastName': 'Doe',
        'age': 30,
      };

      final person = PersonEntity.fromJson(personJson);

      expect(person.firstName, 'John');
      expect(person.lastName, 'Doe');
      expect(person.age, 30);

      expect(person.toJson(), personJson);
    });

    test('copyWith', () {
      final person = PersonEntity(firstName: 'John', lastName: 'Doe', age: 30);
      final copiedPerson = person.copyWith(firstName: 'Jane');

      expect(copiedPerson.firstName, 'Jane');
      expect(copiedPerson.lastName, 'Doe');
      expect(copiedPerson.age, 30);

      final copiedPerson2 = person.copyWith(firstName: '');

      expect(copiedPerson2.firstName, null);
      expect(copiedPerson2.lastName, 'Doe');
      expect(copiedPerson2.age, 30);

      final copiedPerson3 = person.copyWith(lastName: '');

      expect(copiedPerson3.firstName, 'John');
      expect(copiedPerson3.lastName, null);
      expect(copiedPerson3.age, 30);
    });

    test('merge', () {
      final person = PersonEntity(firstName: 'John', lastName: 'Doe', age: 30);
      final otherPerson = PersonEntity(firstName: 'Jane');
      final mergedPerson = person.merge(otherPerson);

      expect(mergedPerson.firstName, 'Jane');
      expect(mergedPerson.lastName, 'Doe');
      expect(mergedPerson.age, 30);
    });
  });
}
