import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_porn/models/user.dart';
import '../models/film.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class FilmProvider extends ChangeNotifier {
  final List<Film> _movies = []; // ✅ Liste des films chargés
  List<Film> _favoriteMovies = []; // ✅ Liste des films favoris
  List<String> _favoriteMovieIds = []; // ✅ Stocke les ID des favoris
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreMovies = true;
  bool _isWebSocketConnected = false;

  List<Film> get films => _movies;
  List<Film> get favoriteFilms => _favoriteMovies; // ✅ Retourne les favoris
  bool get isLoading => _isLoading;
  bool get hasMoreMovies => _hasMoreMovies;
  List<String> get favoriteMovieIds => _favoriteMovieIds;

  FilmProvider() {
    loadFavorites(); // ✅ Charge les favoris au démarrage
  }

  get SharedPreferences => null;

  /// 🔹 Charge les films avec pagination
  Future<void> fetchFilms({bool reset = false}) async {
    if (reset) {
      _movies.clear();
      _currentPage = 1;
      _hasMoreMovies = true;
    }

    if (!_hasMoreMovies) return;
    _isLoading = true;
    notifyListeners();

    try {
      final newMovies = await ApiService.getFilms(page: _currentPage);
      if (newMovies.isEmpty) {
        _hasMoreMovies = false;
      } else {
        _movies.addAll(newMovies);
        _currentPage++;
      }
    } catch (e) {
      debugPrint("❌ Erreur lors du chargement des films : $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Charge les favoris stockés localement
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteMovieIds = prefs.getStringList('favoriteMovies') ?? [];
    await fetchFavoriteFilms(); // ✅ Charge les détails des films favoris
  }

  /// 🔹 Charge les détails des films favoris depuis l'API
  Future<void> fetchFavoriteFilms() async {
    try {
      if (_favoriteMovieIds.isNotEmpty) {
        final favoriteMovies =
            await ApiService.getFavoriteFilms(_favoriteMovieIds);
        _favoriteMovies = favoriteMovies;
      } else {
        _favoriteMovies = [];
      }
    } catch (e) {
      debugPrint("❌ Erreur lors du chargement des favoris : $e");
    }
    notifyListeners();
  }

  /// 🔹 Ajout/Suppression d'un film aux favoris
  Future<void> toggleFavorite(String movieId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favoriteMovieIds.contains(movieId)) {
      _favoriteMovieIds.remove(movieId);
    } else {
      _favoriteMovieIds.add(movieId);
    }

    await prefs.setStringList('favoriteMovies', _favoriteMovieIds);
    await fetchFavoriteFilms(); // ✅ Recharge les favoris après modification
    notifyListeners();
  }

  /// 🔹 Vérifie si un film est en favori
  bool isFavorite(String movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  /// 🔹 Chargement des films en temps réel avec WebSocket
  void initWebSocket() {
    if (_isWebSocketConnected) return;
    _isWebSocketConnected = true;

    ApiService.listenForFilmUpdates((Film newFilm) {
      _movies.insert(0, newFilm);
      notifyListeners();
    });
  }

  /// 🔹 Aimer un film via l'API
  Future<void> likeFilm(String movieId) async {
    try {
      await ApiService.likeFilm(movieId);
      _movies.firstWhere((film) => film.id == movieId).likes++;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Erreur lors du like du film : $e");
    }
  }

  /// 🔹 Actions supplémentaires
  void incrementViewCount(String movieId) {}
  void addFilmToList(Film newFilm) {}
  void addToFavorites(String movieId) {}
  void removeFromFavorites(String movieId) {}
  void addComment({required String movieId, required String comment}) {}
  void deleteComment({required String movieId, required int commentIndex}) {}
}
