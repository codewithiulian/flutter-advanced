import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<bool> signOut() async {
  await _auth.signOut();
  return true;
}

Future<Null> ensureLoggedIn() async {
  FirebaseUser firebaseUser = await _auth.currentUser();
  assert(firebaseUser != null);
  assert(firebaseUser.isAnonymous == false);
  print('We are logged into Firebase > ${firebaseUser.displayName}');
}

Future<bool> signInGoogle() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

  if(user != null && !user.isAnonymous) {
    return true;
  }

  return false;
}

Future<String> getUserId() async {
  await ensureLoggedIn();
  return (await _auth.currentUser()).uid;
}


