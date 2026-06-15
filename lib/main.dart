import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/game_provider.dart';
import 'provider/theme_provider.dart'; // Import file baru
import 'views/splash_screen.dart';     // Import file baru

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()..fetchGames()..loadFavorites()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Daftarkan ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan state dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'RAWG Games',
      // Jika isDarkMode true, gunakan darkTheme, jika false gunakan lightTheme
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const SplashScreen(), // Tampilkan splash screen saat aplikasi pertama kali dibuka
    );
  }
}