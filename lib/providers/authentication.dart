import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                e.message.toString(),
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
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
              title: Text(
                'An error occurred!',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                e.message.toString(),
                style: GoogleFonts.ptSans(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.ptSans(
                      fontSize: 16,
                    ),
                  ),
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

  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
    _token = null;
    _userId = null;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
