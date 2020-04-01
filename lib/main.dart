import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ),);
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {

  String _status;


  @override
  void initState() {
    _status = 'Not Authenticated';
  }

  void _signInAnon() async {
    FirebaseUser user = (await _auth.signInAnonymously()).user;
    if(user != null && user.isAnonymous) {
      setState(() {
        _status = 'Signed in Anonymously';
      });
    } else {
      setState(() {
        _status = 'Sign in failed!';
      });
    }
  }

  void _signInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    if(user != null && !user.isAnonymous) {
      setState(() {
        _status = 'Signed in with Google';
      });
    } else {
      setState(() {
        _status = 'Google sign in failed.';
      });
    }
  }

  void _signOut() async {
    await _auth.signOut();
    setState(() {
      _status = 'Signed out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Firebase'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(_status),
              new RaisedButton(
                onPressed: _signOut,
                child: new Text('Sign out'),
              ),
              new RaisedButton(
                onPressed: _signInAnon,
                child: new Text('Sign in anonymously'),
              ),
              new RaisedButton(
                onPressed: _signInGoogle,
                child: new Text('Sign in Google'),
              ),
            ]
          ),
        ),
      ),
    );
  }
}