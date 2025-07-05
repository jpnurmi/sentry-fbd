import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'envelope.dart';

class EnvelopeViewModel with ChangeNotifier {
  EnvelopeViewModel(this.envelope);

  final Envelope? envelope;

  String get filePath => envelope?.filePath ?? '';
  String get dirname => path.dirname(filePath);
  String get basename => path.basename(filePath);
}
