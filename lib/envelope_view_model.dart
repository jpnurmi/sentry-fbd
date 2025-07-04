import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'envelope_model.dart';

class EnvelopeViewModel with ChangeNotifier {
  EnvelopeViewModel(
    this.filePath, {
    @visibleForTesting fileSystem = const LocalFileSystem(),
  }) : _fileSystem = fileSystem;

  final String filePath;
  final FileSystem _fileSystem;
  Envelope? _envelope;

  String get basename => path.basename(filePath);
  String get dirname => path.dirname(filePath);
  Envelope? get envelope => _envelope;

  Future<void> init() async {
    final bytes = await _fileSystem.file(filePath).readAsBytes();
    _envelope = Envelope.parse(bytes);
  }
}
