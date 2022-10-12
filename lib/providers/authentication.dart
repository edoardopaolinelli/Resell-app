import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';
import '../auth/secrets.dart';

class Authentication with ChangeNotifier {
  String? _token;
  DateTime? _expirationDate;
  String? _userId;
  Timer? _authenticationTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    if (_expirationDate != null &&
        _expirationDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    if (isAuthenticated) {
      return _userId;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=$apiKey');
    //try {
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expirationDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expiresIn']),
      ),
    );
    _autoLogout();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expirationDate': _expirationDate!.toIso8601String(),
    });
    preferences.setString('userData', userData);
    /* } catch (error) {
      throw error;
    } */
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

  Future<bool> automaticLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(preferences.getString('userData') as String)
            as Map<String, dynamic>;
    final expirationDate = DateTime.parse(extractedUserData['expirationDate']);
    if (expirationDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expirationDate = expirationDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expirationDate = null;
    if (_authenticationTimer != null) {
      _authenticationTimer!.cancel();
      _authenticationTimer = null;
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void _autoLogout() {
    if (_authenticationTimer != null) {
      _authenticationTimer!.cancel();
    }
    final remainingTime = _expirationDate!.difference(DateTime.now()).inSeconds;
    _authenticationTimer = Timer(
        Duration(
          seconds: remainingTime,
        ),
        logout);
  }
}
