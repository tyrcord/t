// Dart imports:
import 'dart:io';

// Package imports:
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;

void setUpTStoreTesting() {
  String tempPath = path.join(
    Directory.current.path,
    '.dart_tool',
    'tmp',
    'test',
  );

  Hive.init(tempPath);
}
