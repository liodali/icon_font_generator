import 'package:path_provider/path_provider.dart';

Future<String?> getDocumentDirectory() async =>
    (await getDownloadsDirectory())?.path;
