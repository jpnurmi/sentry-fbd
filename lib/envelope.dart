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
    required this.payloads,
  });

  final String filePath;
  final Map<String, dynamic> header;
  final List<Map<String, dynamic>> items;
  final List<dynamic> payloads;

  static String _prettyFormat(Map<String, dynamic>? json) {
    return JsonEncoder.withIndent('  ').convert(json);
  }

  String formatHeader() {
    return _prettyFormat(header);
  }

  String formatItem(int index) {
    return _prettyFormat(items.elementAtOrNull(index));
  }

  String formatPayload(int index) {
    final payload = payloads.elementAtOrNull(index);
    return switch (payload) {
      Uint8List() =>
        payload
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(' ')
            .toUpperCase(),
      Map<String, dynamic>() => _prettyFormat(payload),
      _ => payload.toString(),
    };
  }

  Map<String, dynamic>? getEvent() {
    final index = items.indexWhere((item) => item['type'] == 'event');
    if (index == -1) return null;
    return payloads.elementAtOrNull(index);
  }

  factory Envelope.fromFile(String? filePath) {
    if (filePath == null) {
      return Envelope(filePath: '', header: {}, items: [], payloads: []);
    }

    final sw = Stopwatch()..start();
    final data = Uint8List.fromList(File(filePath).readAsBytesSync());

    int position = 0;
    final items = <Map<String, dynamic>>[];
    final payloads = <dynamic>[];

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

      items.add(item);
      payloads.add(_decodePayload(payload));
    }

    debugPrint('Loaded $filePath [${sw.elapsedMilliseconds} ms]');
    return Envelope(
      filePath: filePath,
      header: header,
      items: items,
      payloads: payloads,
    );
  }

  static Uint8List _readLine(Uint8List data, int start) {
    for (int i = start; i < data.length; ++i) {
      if (data[i] == kNewline) {
        return Uint8List.sublistView(data, start, i);
      }
    }
    return Uint8List.sublistView(data, start);
  }

  static int _findNext(Uint8List data, int start) {
    for (int i = start; i < data.length - 1; ++i) {
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
      final decoded = utf8.decode(bytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return decoded;
      }
    } catch (e) {
      return bytes;
    }
  }
}
