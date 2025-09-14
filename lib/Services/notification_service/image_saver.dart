import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const _channel = MethodChannel('trust.image_saver');

/// Save already-available bytes with a filename.
Future<bool> saveImageBytes(Uint8List bytes, {required String name}) async {
  final res = await _channel.invokeMethod<Map>('saveImage', {
    'name': name,
    'bytes': bytes,
  });
  return (res?['ok'] == true);
}

/// Convenience: save from URL or local file path.
Future<bool> saveImageToGallery(String source, {String? name}) async {
  Uint8List bytes;
  if (source.startsWith('http')) {
    final r = await http.get(Uri.parse(source));
    if (r.statusCode != 200 || r.bodyBytes.isEmpty) return false;
    bytes = r.bodyBytes;
  } else {
    final f = File(source);
    if (!await f.exists()) return false;
    bytes = await f.readAsBytes();
  }
  final fileName = name ?? 'trust_${DateTime.now().millisecondsSinceEpoch}.jpg';
  return saveImageBytes(bytes, name: fileName);
}
