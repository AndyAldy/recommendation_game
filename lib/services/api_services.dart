import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class ApiService {
  static const String _baseUrl = 'https://api.rawg.io/api';
  static const String _apiKey = 'dd9ae09496e34493a4ca513c742f16a1'; // Ganti dengan key dari https://rawg.io/apidocs

  Future<List<Game>> getGames(int page, int pageSize) async {
    final response = await http.get(Uri.parse('$_baseUrl/games?key=$_apiKey&page=$page&page_size=$pageSize'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    }
    throw Exception('Gagal memuat data game');
  }

  Future<List<Game>> searchGames(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/games?search=$query&key=$_apiKey'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['results'];
      return data.map((json) => Game.fromJson(json)).toList();
    }
    throw Exception('Gagal mencari game');
  }
  
  Future<Map<String, dynamic>> getGameDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/games/$id?key=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Gagal memuat detail game');
  }
}