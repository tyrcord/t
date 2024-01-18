// Project imports:
import 'package:tstore/tstore.dart';

class PersonEntity extends TEntity {
  late final String? firstName;
  late final String? lastName;
  late final int? age;

  // Constructor
  PersonEntity({
    String? firstName,
    String? lastName,
    int? age,
  }) {
    this.firstName = assignValue(firstName);
    this.lastName = assignValue(lastName);
    this.age = assignValue(age);
  }

  // Clone Method
  @override
  PersonEntity clone() => copyWith();

  // From JSON Factory
  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      age: json['age'] as int?,
    );
  }

  // Copy With Method
  @override
  PersonEntity copyWith({
    String? firstName,
    String? lastName,
    int? age,
  }) {
    return PersonEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
    );
  }

  // Copy With Defaults Method
  @override
  PersonEntity copyWithDefaults({
    bool resetFirstName = false,
    bool resetLastName = false,
    bool resetAge = false,
  }) {
    return PersonEntity(
      firstName: resetFirstName ? null : firstName,
      lastName: resetLastName ? null : lastName,
      age: resetAge ? null : age,
    );
  }

  // Merge Method
  @override
  PersonEntity merge(covariant PersonEntity other) {
    return copyWith(
      firstName: other.firstName,
      lastName: other.lastName,
      age: other.age,
    );
  }

  // Props Getter
  @override
  List<Object?> get props => [firstName, lastName, age];

  // To JSON Method
  @override
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
    };
  }
}
