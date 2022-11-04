import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication with ChangeNotifier {
  String? _token;
  String? _userId;

  bool get isAuthenticated {
    return _token != null;
  }

  String? get token {
    return _token;
  }

  String? get userId {
    if (isAuthenticated) {
      return _userId;
    }
    return null;
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _token = await FirebaseAuth.instance.currentUser!.getIdToken();
      _userId = FirebaseAuth.instance.currentUser!.uid;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('An error occurred!'),
              content: Text(e.message.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _token = await FirebaseAuth.instance.currentUser!.getIdToken();
      _userId = FirebaseAuth.instance.currentUser!.uid;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('An error occurred!'),
              content: Text(e.message.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  Future<bool> automaticLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(preferences.getString('userData') as String)
            as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    notifyListeners();
    return true;
  }

  //da sostituire completamente
  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
