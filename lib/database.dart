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

Future<int> getCounter() async {
  int value;
  await counterRef.once().then((DataSnapshot snapshot) {
    print('Connected to DB and read ${snapshot.value}');
    value = snapshot.value;
  });
  return value;
}

Future<Null> setCounter(int value) async {
  TransactionResult transactionResult =
    await counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = value;
      return mutableData;
    });

  if(transactionResult.committed) {
    print('Saved the value to the database');
  } else {
    print('Transaction not commited!');
    if(transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
}

Future<Null> addData(String user) async {
  DatabaseReference messageRef =
    FirebaseDatabase.instance.reference().child('messages/$user');
  for(int i = 0; i < 20; i++) {
    messageRef
        .update(<String, String>{'Key${i.toString()}' : 'Body${i.toString()}'});
  }
}

Future<Null> removeData(String user) async {
  DatabaseReference messageRef =
  FirebaseDatabase.instance.reference().child('messages/$user');
  for(int i = 0; i < 20; i++) {
    await messageRef.remove();
  }
}

Future<Null> setData(String user, String key, String value) async {
  DatabaseReference messageRef =
  FirebaseDatabase.instance.reference().child('messages/$user');
  for(int i = 0; i < 20; i++) {
    messageRef.set(<String, String>{key : value});
  }
}

Future<Null> updateData(String user, String key, String value) async {
  DatabaseReference messageRef =
  FirebaseDatabase.instance.reference().child('messages/$user');
  for(int i = 0; i < 20; i++) {
    messageRef.update(<String, String>{key : value});
  }
}