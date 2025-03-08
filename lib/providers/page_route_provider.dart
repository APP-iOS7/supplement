import 'package:flutter/material.dart';

class PageRouteProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void navigateToMain() {
    _currentIndex = 0;
    notifyListeners();
  }

  void navigateToHealthCheck() {
    _currentIndex = 1;
    notifyListeners();
  }

  void goBack() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }
}
