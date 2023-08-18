import 'package:flutter_test/flutter_test.dart';

import '../../mocks/entities/person.entity.dart';

void main() {
  group('PersonEntity', () {
    test('fromJson and toJson', () {
      final personJson = {
        'firstname': 'John',
        'lastname': 'Doe',
        'age': 30,
      };

      final person = PersonEntity.fromJson(personJson);

      expect(person.firstname, 'John');
      expect(person.lastname, 'Doe');
      expect(person.age, 30);

      expect(person.toJson(), personJson);
    });

    test('copyWith', () {
      const person = PersonEntity(firstname: 'John', lastname: 'Doe', age: 30);
      final copiedPerson = person.copyWith(firstname: 'Jane');

      expect(copiedPerson.firstname, 'Jane');
      expect(copiedPerson.lastname, 'Doe');
      expect(copiedPerson.age, 30);

      final copiedPerson2 = person.copyWith(firstname: '');

      expect(copiedPerson2.firstname, null);
      expect(copiedPerson2.lastname, 'Doe');
      expect(copiedPerson2.age, 30);

      final copiedPerson3 = person.copyWith(lastname: '');

      expect(copiedPerson3.firstname, 'John');
      expect(copiedPerson3.lastname, null);
      expect(copiedPerson3.age, 30);
    });

    test('merge', () {
      const person = PersonEntity(firstname: 'John', lastname: 'Doe', age: 30);
      const otherPerson = PersonEntity(firstname: 'Jane');
      final mergedPerson = person.merge(otherPerson);

      expect(mergedPerson.firstname, 'Jane');
      expect(mergedPerson.lastname, 'Doe');
      expect(mergedPerson.age, 30);
    });
  });
}
