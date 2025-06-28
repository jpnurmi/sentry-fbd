import 'package:flutter/foundation.dart';

import 'argument_model.dart';

class ArgumentViewModel with ChangeNotifier {
  ArgumentViewModel(List<String> args) : _args = args {
    filter('');
  }

  final List<String> _args;
  List<ArgumentModel> _filtered = [];

  List<ArgumentModel> get args => _filtered;

  void filter(String filter) {
    _filtered = _args
        .where(
          (key) =>
              filter.isEmpty ||
              key.toLowerCase().contains(filter.toLowerCase()),
        )
        .map(ArgumentModel.new)
        .toList();
    notifyListeners();
  }
}
