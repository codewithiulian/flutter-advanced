import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

int counter;
DatabaseReference counterRef;
DatabaseError error;

Future<Null> init(FirebaseDatabase database) async {
  counterRef = FirebaseDatabase.instance.reference().child('test/counter');
  counterRef.keepSynced(true);
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);
}

Future<Map<dynamic, dynamic>> findData(String user, String key) async {
  DatabaseReference _messageRef = FirebaseDatabase.instance.reference()
      .child('messages/$user');
  Map<dynamic, dynamic> value;
  Query query = _messageRef.equalTo(value, key: key);
  await query.once().then((snapshot) => value = snapshot.value);

  return value;
}

Future<Map<dynamic, dynamic>> findRange(String user, String key) async {
  DatabaseReference _messageRef = FirebaseDatabase.instance.reference()
      .child('messages/$user');
  Map<dynamic, dynamic> value;
  Query query = _messageRef.endAt(value, key: key);
  await query.once().then((snapshot) => value = snapshot.value);
  print(value);
  return value;
}

