import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

const kNewline = 10; // '\n'
const kOpenBrace = 123; // '{'

class Envelope {
  const Envelope({
    required this.filePath,
    required this.header,
    required this.items,
  });

  final String filePath;
  final Map<String, dynamic> header;
  final List<Map<String, dynamic>> items;

  Map<String, dynamic>? getEvent() {
    return items.firstWhereOrNull(
      (item) => item['type'] == 'event',
    )?['payload'];
  }

  @override
  String toString() {
    final sw = Stopwatch()..start();
    final buffer = StringBuffer();
    buffer.write(json.encode(header));
    for (final item in items) {
      buffer.writeln();
      final header = Map.of(item);
      final payload = header.remove('payload');
      buffer.writeln(json.encode(header));
      if (payload is Uint8List) {
        buffer.writeln('[${payload.length} bytes]');
      } else {
        try {
          buffer.writeln(json.encode(payload));
        } catch (e) {
          buffer.writeln(payload.toString());
        }
      }
    }
    debugPrint('Formatted $filePath [${sw.elapsedMilliseconds} ms]');
    return buffer.toString();
  }

  factory Envelope.fromFile(String? filePath) {
    if (filePath == null) return Envelope(filePath: '', header: {}, items: []);
    final sw = Stopwatch()..start();
    final data = Uint8List.fromList(File(filePath).readAsBytesSync());

    int position = 0;
    final items = <Map<String, dynamic>>[];

    var line = _readLine(data, position);
    position += line.length + 1; // \n

    final header = json.decode(utf8.decode(line));

    while (position < data.length) {
      line = _readLine(data, position);
      position += line.length + 1; // \n

      final item = json.decode(utf8.decode(line));

      int length = item['length'] ?? _findNext(data, position) - position;

      final payload = data.sublist(position, position + length);
      position += length;

      if (position < data.length && data[position] == kNewline) {
        position++;
      }

      items.add({...item, 'payload': ?_decodePayload(payload)});
    }

    debugPrint('Loaded $filePath [${sw.elapsedMilliseconds} ms]');
    return Envelope(filePath: filePath, header: header, items: items);
  }

  static Uint8List _readLine(Uint8List data, int start) {
    for (int i = start; i < data.length; i++) {
      if (data[i] == kNewline) {
        return data.sublist(start, i);
      }
    }
    return data.sublist(start);
  }

  static int _findNext(Uint8List data, int start) {
    for (int i = start; i < data.length - 1; i++) {
      if (data[i] == kNewline && data[i + 1] == kOpenBrace) {
        return i;
      }
    }
    return data.length;
  }

  static dynamic _decodePayload(Uint8List bytes) {
    if (bytes.isEmpty) {
      return null;
    }
    try {
      return json.decode(utf8.decode(bytes));
    } catch (e) {
      try {
        return utf8.decode(bytes);
      } catch (e) {
        return bytes;
      }
    }
  }
}
