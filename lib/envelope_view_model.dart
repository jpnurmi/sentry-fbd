import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'envelope_model.dart';

class EnvelopeViewModel with ChangeNotifier {
  EnvelopeViewModel({@visibleForTesting fileSystem = const LocalFileSystem()})
    : _fileSystem = fileSystem;

  final FileSystem _fileSystem;
  String? _filePath;
  Envelope? _envelope;

  String get basename => path.basename(_filePath ?? '');
  String get dirname => path.dirname(_filePath ?? '');
  Envelope? get envelope => _envelope;

  Future<void> load(String? filePath) async {
    _filePath = filePath;
    notifyListeners();

    if (filePath != null) {
      final bytes = await _fileSystem.file(filePath).readAsBytes();
      _envelope = Envelope.parse(bytes);
    } else {
      _envelope = null;
    }
    notifyListeners();
  }
}
