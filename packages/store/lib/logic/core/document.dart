// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:tstore/tstore.dart';

/// A document is a collection of key-value pairs.
abstract class TDocument extends TEntity {
  /// The version of the document.
  int get version => 0;

  const TDocument();

  /// Returns a JSON representation of this object.
  @override
  @override
  Map<String, dynamic> toJson() => {'version': version};

  /// Returns a string representation of this object.
  @override
  String toString() => jsonEncode(toJson());
}
