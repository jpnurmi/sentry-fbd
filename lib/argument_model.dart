import 'dart:io';

class ArgumentModel {
  final String key;
  final String value;

  ArgumentModel(String arg) : this._fromParts(arg.split('='));

  ArgumentModel._fromParts(List<String> parts)
    : key = parts.length > 1 ? parts.first : '',
      value = parts.length > 1 ? parts.skip(1).join('=') : parts.single;

  bool get isFile => File(value).existsSync();

  @override
  String toString() => key.isEmpty ? value : '$key=$value';
}
