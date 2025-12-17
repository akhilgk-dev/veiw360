import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File> downloadImage(String url) async {
  final response = await http.get(Uri.parse(url));
  final documentDirectory = await getApplicationDocumentsDirectory();
  final file = File('${documentDirectory.path}/image.jpg');
  file.writeAsBytesSync(response.bodyBytes);
  return file;
}
