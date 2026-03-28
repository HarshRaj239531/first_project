import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;
  String _userName = '';
  String _userEmail = '';

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  String get userName => _userName;
  String get userEmail => _userEmail;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      if (email.isNotEmpty && password.length >= 8) {
        _isLoggedIn = true;
        _userEmail = email;
        _userName = email.split('@').first;
      } else {
        _errorMessage = 'Invalid credentials. Please try again.';
      }
    } catch (_) {
      _errorMessage = 'Login failed. Please try again.';
    }
    _setLoading(false);
  }

  Future<void> signup(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
    } catch (_) {
      _errorMessage = 'Signup failed. Please try again.';
    }
    _setLoading(false);
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
