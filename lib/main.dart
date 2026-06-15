import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/game_provider.dart';
import 'views/main_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()..fetchGames()..loadFavorites()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAWG Games',
      theme: ThemeData.dark(),
      home: MainNavigation(),
    );
  }
}