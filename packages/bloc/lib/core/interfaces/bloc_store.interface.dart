// Project imports:
import 'package:tbloc/tbloc.dart';

/// A store that persists and retrieves values from [BlocState]s.
abstract class BlocStore<S extends BlocState> {
  /// Retrieves the [value] for the given [key].
  Future<S?> retrieve(String key);

  /// Persits the [value] for the given [key].
  Future<S?> persist(String key, S value);

  /// Deletes the [value] for the given [key].
  Future<S?> delete(String key);

  /// Clears the store.
  /// - This method will delete all the [value]s for all the [key]s.
  /// - This method will not delete the store itself.
  Future<void> clear();
}
