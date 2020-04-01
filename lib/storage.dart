import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'auth.dart' as auth;
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

Future<String> upload(File file, String basename) async {
  await auth.ensureLoggedIn();

  StorageReference ref =
    FirebaseStorage.instance.ref().child('file/test/${basename}');
  StorageUploadTask uploadTask = ref.putFile(
    file,
    StorageMetadata(
      contentLanguage: 'en',
      customMetadata: <String, String>{'activity': 'test'},
    )
  );
  String location = await ref.getDownloadURL();
  String name = await ref.getName();
  String bucket = await ref.getBucket();
  String path = await ref.getPath();

  print('> File uploaded');
  print('> Url: $location');
  print('> Name: $name');
  print('> Bucket: $bucket');
  print('> Path: $path');

  return location;
}

Future<String> download(Uri location) async {
  http.Response data = await http.get(location);
  print('Print: ${'https://firebasestorage.googleapis.com/v0/b/fir-app-eb02c.appspot.com/o/file%2Ftest%2Ffoo.txt?alt=media&token=02a6ab86-a2c2-4fe0-868a-7083bc2c657c'}');
  return data.body;
}
