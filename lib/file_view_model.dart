import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/all.dart' as highlight;
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
    final file = _fileSystem.file(filePath);
    _content = await file.readAsString();
    _language = highlight.allLanguages[path.extension(filePath).substring(1)];
  }
}
