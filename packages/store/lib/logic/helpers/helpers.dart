import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:hive/hive.dart';

void setUpTStoreTesting() {
  String tempPath = path.join(
    Directory.current.path,
    '.dart_tool',
    'tmp',
    'test',
  );

  Hive.init(tempPath);
}
