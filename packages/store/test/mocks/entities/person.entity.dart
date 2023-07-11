// Project imports:
import 'package:tstore/tstore.dart';

class PersonEntity extends TEntity {
  final String? firstname;
  final String? lastname;
  final int? age;

  const PersonEntity({
    this.firstname,
    this.lastname,
    this.age,
  });

  @override
  PersonEntity clone() {
    return PersonEntity(
      firstname: firstname,
      lastname: lastname,
      age: age,
    );
  }

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      age: json['age'] as int?,
    );
  }

  @override
  PersonEntity copyWith({
    String? firstname,
    String? lastname,
    int? age,
  }) {
    return PersonEntity(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
    );
  }

  @override
  PersonEntity merge(covariant PersonEntity entity) {
    return copyWith(
      firstname: entity.firstname,
      lastname: entity.lastname,
      age: entity.age,
    );
  }

  @override
  List<Object?> get props => [firstname, lastname, age];

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
    };
  }
}
