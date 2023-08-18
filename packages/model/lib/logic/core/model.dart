// Package imports:
import 'package:equatable/equatable.dart';

///
/// Abstract class that enforces certain properties on an TModel object.
///
abstract class TModel extends Equatable {
  const TModel();

  ///
  /// Creates a copy of this TModel but with the given fields replaced
  /// with the new values.
  ///
  /// For example:
  ///
  ///     var myModel2 = myModel1.copyWith(age: 42);
  TModel copyWith();

  ///
  /// Creates a new TModel where each properties from this object has been
  /// merged with the matching properties from the other object.
  ///
  /// For example:
  ///
  ///     var myModel3 = myModel1.merge(myModel2);
  TModel merge(TModel model);

  ///
  /// Creates a copy of this TModel.
  ///
  /// For example:
  ///
  ///     var myModel2 = myModel1.clone();
  TModel clone();

  T assignValue<T>(T? value, T? defaultValue, {bool loose = true}) {
    if (loose) {
      if (value is String && value.isEmpty) {
        return null as T;
      }
    }

    return value ?? defaultValue!;
  }
}
