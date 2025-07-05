import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'envelope.dart';

class EnvelopeViewModel with ChangeNotifier {
  EnvelopeViewModel(this._envelope);

  final Envelope? _envelope;

  String get basename => path.basename(_envelope?.filePath ?? '');
  String get dirname => path.dirname(_envelope?.filePath ?? '');

  Future<String?> init() async => _envelope?.toString();
}
