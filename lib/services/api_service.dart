import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';
import '../models/film.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: "${Config.apiUrl}/api",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// 🔹 **Ajoute un film (Admin & Super Admin uniquement)**
  static Future<Film> addFilm({
    required String title,
    required String description,
    required String posterUrl,
    required String category,
    required String token,
  }) async {
    final response = await _dio.post(
      "/films",
      options: Options(headers: {"Authorization": "Bearer $token"}),
      data: jsonEncode({
        "title": title,
        "description": description,
        "posterUrl": posterUrl,
        "category": category,
      }),
    );

    if (response.statusCode == 201) {
      return Film.fromJson(response.data);
    } else {
      throw Exception("⛔ Erreur lors de l'ajout du film.");
    }
  }

  /// 🔹 **Récupère tous les films**
  static Future<List<Film>> getFilms({required int page}) async {
    final response = await _dio.get("/films");

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Film.fromJson(json))
          .toList();
    } else {
      throw Exception("⛔ Erreur lors du chargement des films.");
    }
  }

  /// 🔹 **Supprime un film (Admin & Super Admin uniquement)**
  static Future<void> deleteFilm(String movieId) async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("⛔ Authentification requise.");

    final response = await _dio.delete(
      "/films/$movieId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("⛔ Erreur lors de la suppression du film.");
    }
  }

  /// 🔹 **Ajoute un film aux favoris**
  static Future<void> addFavorite(String movieId) async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("⛔ Authentification requise.");

    final response = await _dio.post(
      "/favorites",
      options: Options(headers: {"Authorization": "Bearer $token"}),
      data: jsonEncode({"filmId": movieId}),
    );

    if (response.statusCode != 200) {
      throw Exception("⛔ Erreur lors de l'ajout aux favoris.");
    }
  }

  /// 🔹 **Supprime un film des favoris**
  static Future<void> removeFavorite(String movieId) async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("⛔ Authentification requise.");

    final response = await _dio.delete(
      "/favorites/$movieId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("⛔ Erreur lors de la suppression des favoris.");
    }
  }

  /// 🔹 **Récupère les films favoris de l'utilisateur**
  static Future<List<Film>> getFavorites() async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("⛔ Authentification requise.");

    final response = await _dio.get(
      "/favorites",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Film.fromJson(json))
          .toList();
    } else {
      throw Exception("⛔ Erreur lors du chargement des favoris.");
    }
  }

  /// 🔹 **Récupère tous les films (Admin)**
  static Future<List<Film>> getAllFilms() async {
    final response = await _dio.get("/films/all");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Film.fromJson(json))
          .toList();
    } else {
      throw Exception("⛔ Erreur lors du chargement des films.");
    }
  }

  /// 🔹 **Récupère tous les utilisateurs (Admin & Super Admin)**
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _dio.get("/users/all");
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception("⛔ Erreur lors du chargement des utilisateurs.");
    }
  }

  /// 🔹 **Bannir un utilisateur (Super Admin uniquement)**
  static Future<void> banUser(String userId) async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("⛔ Authentification requise.");

    final response = await _dio.post(
      "/users/ban/$userId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("⛔ Erreur lors du bannissement de l'utilisateur.");
    }
  }

  /// 🔹 **Aimer un film via l'API**
  static Future<void> likeFilm(String movieId) async {
    final token = await _storage.read(key: "token");
    if (token == null) throw Exception("⛔ Authentification requise.");

    final response = await _dio.post(
      "/films/$movieId/like",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("⛔ Erreur lors du like du film.");
    }
  }

  /// 🔹 **Écoute les mises à jour des films via WebSocket (non implémenté)**
  static void listenForFilmUpdates(void Function(Film newFilm) callback) {
    throw UnimplementedError("WebSocket non encore implémenté.");
  }

  /// 🔹 **Récupère la liste des catégories**
  static Future<List<String>> getCategories() async {
    final response = await _dio.get("/categories");
    if (response.statusCode == 200) {
      return List<String>.from(response.data);
    } else {
      throw Exception("⛔ Erreur lors du chargement des catégories.");
    }
  }

  static getFavoriteFilms(List<String> favoriteMovieIds) {}
}
