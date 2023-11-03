// Package imports:
import 'package:tmodel/tmodel.dart';

/// The document changes model.
/// This is the base class for all document changes models.
/// It is used to notify the UI of changes in the document.
class TDocumentChanges extends TModel {
  /// The entries to update.
  final Map<String, dynamic> entryToUpdate;

  /// The keys to delete.
  final Iterable<String> keyToDelete;

  const TDocumentChanges({
    required this.entryToUpdate,
    required this.keyToDelete,
  });

  /// Clone this object.
  @override
  TDocumentChanges clone() => copyWith();

  /// Copy this object with the given parameters.
  @override
  TDocumentChanges copyWith({
    Map<String, dynamic>? entryToUpdate,
    Iterable<String>? keyToDelete,
  }) {
    return TDocumentChanges(
      entryToUpdate: entryToUpdate ?? this.entryToUpdate,
      keyToDelete: keyToDelete ?? this.keyToDelete,
    );
  }

  /// Merge this object with the given model.
  /// This method is used to merge the changes of a document.
  @override
  TDocumentChanges merge(covariant TDocumentChanges model) {
    return copyWith(
      entryToUpdate: model.entryToUpdate,
      keyToDelete: model.keyToDelete,
    );
  }

  /// Gets the properties of this object.
  /// This getter is used to compare objects.
  @override
  List<Object> get props => [entryToUpdate, keyToDelete];
}
