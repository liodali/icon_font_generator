import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

import '../../icon_font_generator.dart';

// Future<web.File?> openFile() {
//   final completer = Completer<web.File>();

//   final input = web.document.createElement('input') as web.HTMLInputElement;
//   input.type = 'file';
//   input.click();
//   input.onchange = (e) {
//     final file = (e.target as web.HTMLInputElement).files?.item(0);
//     completer.complete(file);
//   }.toJS;

//   return completer.future;
// }

/// Reads OpenType font from a file.
Future<OpenTypeFont> readFromFile(String path) async =>
    throw UnimplementedError();

/// Writes OpenType font to a file.
void writeToFile(String path, OpenTypeFont font) {
  final emptyBytes = ByteData(font.size);
  font.encodeToBinary(emptyBytes);
  final blob = web.Blob([emptyBytes.buffer.toJS].toJS);
  final a = web.document.createElement('a') as web.HTMLAnchorElement;
  a.href = web.URL.createObjectURL(blob);
  a.download = path;
  a.click();
  web.URL.revokeObjectURL(a.href);
}
