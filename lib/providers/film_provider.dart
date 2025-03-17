import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/film.dart';

class FilmProvider extends ChangeNotifier {
  final List<Film> _movies = [];
  final List<String> _trendingCategories = [];
  final _uuid = Uuid();
  Timer? _trendingTimer;

  // On expose des listes non modifiables
  List<Film> get films => List.unmodifiable(_movies);
  List<String> get trendingCategories => List.unmodifiable(_trendingCategories);

  // Méthode pour ajouter un film
  void addFilm({
    required String title,
    required String description,
    required String posterUrl,
    required String category,
  }) {
    final newFilm = Film(
      id: _uuid.v4(),
      titre: titleCase(title),
      description: description,
      affiche: posterUrl,
      category: category,
    );
    _movies.add(newFilm);
    notifyListeners();
  }

  // Récupérer les catégories tendances
  List<String> getTrendingCategories() => _trendingCategories;

  // Incrémente le nombre de likes d'un film
  void likeFilm(String movieId) {
    final film = _movies.firstWhere((film) => film.id == movieId);
    film.likes++; // Incrémente le compteur de likes
    notifyListeners();
  }

  // Incrémente le nombre de vues d'un film
  void incrementViewCount(String movieId) {
    final film = _movies.firstWhere((film) => film.id == movieId);
    film.views++; // Incrémente le compteur de vues
    notifyListeners();
  }

  // Ajoute un commentaire à un film
  void addComment({required String movieId, required String comment}) {
    final film = _movies.firstWhere((film) => film.id == movieId);
    film.comments.add(comment);
    notifyListeners();
  }

  // Supprime un film
  void deleteFilm(String movieId) {
    _movies.removeWhere((film) => film.id == movieId);
    notifyListeners();
  }

// Supprime un commmentaire
  void deleteComment({required String movieId, required int commentIndex}) {
    final film = _movies.firstWhere((film) => film.id == movieId);
    film.comments.removeAt(commentIndex);
    notifyListeners();
  }

  // Met à jour les catégories tendances en se basant sur les vues
  void updateTrendingCategories() {
    final sortedMovies = [..._movies];
    sortedMovies.sort((a, b) => b.views.compareTo(a.views));

    final Set<String> trending = {};
    for (var film in sortedMovies.take(3)) {
      trending.add(film.category);
    }

    _trendingCategories
      ..clear()
      ..addAll(trending);

    notifyListeners();
  }

  // Démarre la mise à jour périodique des catégories tendances
  void startTrendingUpdates() {
    _trendingTimer?.cancel();
    _trendingTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      updateTrendingCategories();
    });
  }

  // Arrête la mise à jour périodique
  void stopTrendingUpdates() {
    _trendingTimer?.cancel();
  }

  // Met en majuscule la première lettre de chaque mot
  String titleCase(String text) => text
      .split(' ')
      .map((e) => "${e[0].toUpperCase()}${e.substring(1)}")
      .join(' ');
}
