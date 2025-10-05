import 'dart:async';
import '../otf.dart' show OpenTypeFont;
import 'stub.dart'
    if (dart.library.io) 'io.dart'
    if (dart.library.js_interop) 'web.dart';

Future<OpenTypeFont> readFontFile(dynamic fontFile) async {
  return readFromFile(fontFile.path);
}

void writeFontFile(String path, OpenTypeFont font) => writeToFile(path, font);
