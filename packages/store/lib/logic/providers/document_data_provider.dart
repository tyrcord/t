// Project imports:
import 'package:tstore/tstore.dart';

/// A document data provider.
abstract class TDocumentDataProvider extends TDataProvider {
  TDocumentDataProvider({required super.storeName});

  /// Persists the document in the store.
  Future<void> persistDocument(TDocument document) async {
    final oldRaw = await store.toMap();
    final newRaw = document.toJson();
    final changes = _findActualDocumentChanges(oldRaw, newRaw);

    for (final entry in changes.entryToUpdate.entries) {
      await store.persist(entry.key, entry.value);
    }

    for (final key in changes.keyToDelete) {
      await store.delete(key);
    }
  }

  /// Clears the document from the store.
  Future<void> clearDocument() async => store.clear();

  /// Finds the actual document changes.
  /// This method is used to avoid unnecessary updates.
  TDocumentChanges _findActualDocumentChanges(
    Map<String, dynamic> oldDocument,
    Map<String, dynamic> newDocument,
  ) {
    final entryToUpdate = <String, dynamic>{};
    final keyToDelete = <String>[];

    oldDocument.forEach((String key, dynamic value) {
      if (newDocument.containsKey(key)) {
        if (oldDocument[key] != newDocument[key]) {
          entryToUpdate[key] = newDocument[key];
        }
      } else {
        keyToDelete.add(key);
      }
    });

    newDocument.forEach((String key, dynamic value) {
      if (!oldDocument.containsKey(key)) {
        entryToUpdate[key] = value;
      }
    });

    return TDocumentChanges(
      entryToUpdate: entryToUpdate,
      keyToDelete: keyToDelete,
    );
  }
}
