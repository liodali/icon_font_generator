import 'stub_get_directory.dart'
    if (dart.library.io) 'io_get_dowload_path.dart.dart'
    if (dart.library.js_interop) 'web_get_directory.dart';

Future<String?> getDownloadsDirectory() => getDocumentDirectory();
