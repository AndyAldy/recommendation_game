import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Secara default menggunakan dark mode agar sesuai dengan mockup awal
  bool _isDarkMode = true; 

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Memberitahu seluruh aplikasi untuk mengganti tema
  }
} 