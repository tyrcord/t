// Package imports:
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:tstore/tstore.dart';

/// The store changes model.
/// This is the base class for all store changes models.
/// It is used to notify the UI of changes in the store.
class TStoreChanges extends TModel {
  /// The type of change.
  final TStoreChangeType type;

  /// The value of the change.
  final dynamic value;

  /// The key of the change.
  final String? key;

  const TStoreChanges({
    required this.type,
    this.value,
    this.key,
  });

  /// Clone this object.
  @override
  TStoreChanges clone() {
    return TStoreChanges(
      value: value,
      type: type,
      key: key,
    );
  }

  /// Copy this object with the given parameters.
  @override
  TStoreChanges copyWith({
    TStoreChangeType? type,
    dynamic value,
    String? key,
  }) {
    return TStoreChanges(
      value: value ?? this.value,
      type: type ?? this.type,
      key: key ?? this.key,
    );
  }

  /// Merge this object with the given model.
  @override
  TStoreChanges merge(covariant TStoreChanges model) {
    return copyWith(
      value: model.value,
      type: model.type,
      key: model.key,
    );
  }

  /// Gets the properties of this object.
  /// This getter is used to compare objects.
  @override
  List<Object?> get props => [type, key, value];
}
