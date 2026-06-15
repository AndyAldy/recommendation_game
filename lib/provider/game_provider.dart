import 'package:flutter/material.dart';
import '../models/game.dart';
import '/services/api_services.dart';
import '/services/database_helper.dart';

class GameProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Game> games = [];
  List<Game> favoriteGames = [];
  bool isLoading = false;
  int currentPage = 1;

  Future<void> fetchGames() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    
    try {
      final newGames = await _apiService.getGames(currentPage, 10);
      games.addAll(newGames);
      currentPage++;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchGames(String query) async {
    isLoading = true;
    notifyListeners();
    try {
      games = await _apiService.searchGames(query);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    favoriteGames = await _dbHelper.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Game game) async {
    final isExist = favoriteGames.any((g) => g.id == game.id);
    if (isExist) {
      await _dbHelper.removeFavorite(game.id);
    } else {
      await _dbHelper.addFavorite(game);
    }
    await loadFavorites(); // Refresh list favorite
  }

  bool isFavorite(int id) {
    return favoriteGames.any((game) => game.id == id);
  }
}