import 'package:tmodel/tmodel.dart';

/// Entity objects are classes that encapsulate the business model,
/// and are used to transfer data between the UI and the business logic.
/// - They are immutable.
/// - They are serializable.
/// - They are comparable.
abstract class TEntity extends TModel {
  const TEntity();

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson();
}
