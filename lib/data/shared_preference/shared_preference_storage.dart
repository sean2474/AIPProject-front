// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveValue(String key, String value) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString(key, value);
// }

// Future<String?> readValue(String key) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString(key);
// }

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> saveValue(String key, String value) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$key.txt');
  await file.writeAsString(value);
}

Future<String?> readValue(String key) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$key.txt');
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      return null;
    }
  } catch (e) {
    print('Error reading value for key $key: $e');
    return null;
  }
}

Future<void> resetValue(String key) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$key.txt');
  if (await file.exists()) {
    await file.delete();
  }
}

Future<void> resetAllValues() async {
  final directory = await getApplicationDocumentsDirectory();
  final files = directory.listSync();
  for (var entity in files) {
    if (entity is File) {
      await entity.delete();
    }
  }
}
