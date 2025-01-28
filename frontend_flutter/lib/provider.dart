import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  String _token = "";

  String get token => _token;


  void setToken(String value) {
    _token = value; // Set any value
    notifyListeners();
  }
}
