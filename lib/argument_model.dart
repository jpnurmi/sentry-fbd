import 'dart:io';

class ArgumentModel {
  final String key;
  final String value;

  ArgumentModel(String arg)
    : key = arg.split('=').first,
      value = arg.split('=').sublist(1).join('=');

  bool get isFile => File(value).existsSync();

  @override
  String toString() => value.isEmpty ? key : '$key=$value';
}
