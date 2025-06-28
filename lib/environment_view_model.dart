import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';

class EnvironmentViewModel with ChangeNotifier {
  EnvironmentViewModel([Platform platform = const LocalPlatform()])
    : _platform = platform {
    filter('SENTRY');
  }

  final Platform _platform;
  List<String> _keys = [];

  int get length => _keys.length;
  String key(int index) => _keys[index];
  String? value(int index) => _platform.environment[_keys[index]];

  void filter(String filter) {
    _keys = _platform.environment.keys
        .where(
          (key) =>
              filter.isEmpty ||
              key.toLowerCase().contains(filter.toLowerCase()),
        )
        .sorted()
        .toList();
    notifyListeners();
  }
}
