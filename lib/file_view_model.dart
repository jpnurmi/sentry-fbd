import 'dart:convert';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart' as highlight;
import 'package:msgpack_dart/msgpack_dart.dart' as msgpack;
import 'package:path/path.dart' as path;

class FileViewModel with ChangeNotifier {
  FileViewModel(
    this.filePath, {
    @visibleForTesting fileSystem = const LocalFileSystem(),
  }) : _fileSystem = fileSystem;

  final String filePath;
  final FileSystem _fileSystem;
  String? _content;
  Mode? _language;

  String get basename => path.basename(filePath);
  String get dirname => path.dirname(filePath);
  String get content => _content ?? '';
  Mode? get language => _language;

  Future<void> init() async {
    final bytes = await _fileSystem.file(filePath).readAsBytes();
    try {
      _content = utf8.decode(bytes);
    } on FormatException {
      _content = json.encode(msgpack.deserialize(bytes));
    }
    final ext = path.extension(filePath);
    _language = highlight.allLanguages[ext.isEmpty ? 'json' : ext.substring(1)];
  }
}
