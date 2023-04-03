import 'dart:convert';

import 'package:tstore/tstore.dart';

/// A document is a collection of key-value pairs.
abstract class TDocument extends TEntity {
  const TDocument();

  /// Returns a JSON representation of this object.
  @override
  Map<String, dynamic> toJson();

  /// Returns a string representation of this object.
  @override
  String toString() => jsonEncode(toJson());
}
