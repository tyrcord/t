import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:hive/hive.dart';

void setUpTStoreTesting() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String tempPath = path.join(
    Directory.current.path,
    '.dart_tool',
    'tmp',
    'test',
  );

  Hive.init(tempPath);
}
