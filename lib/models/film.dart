import 'dart:convert';

class Film {
  final String id;
  final String titre;
  final String description;
  final String affiche;
  final String category;
  final String ownerId;
  final int duration;
  int views;
  int likes;
  double rating;
  List<double> ratings;
  List<String> comments;
  bool isFavorite;
  final DateTime createdAt;
  DateTime updatedAt;
  List<int> viewsHistory;
  double recommendScore;

  Film({
    required this.id,
    required this.titre,
    required this.description,
    required this.affiche,
    required this.category,
    required this.ownerId,
    required this.duration,
    this.views = 0,
    this.likes = 0,
    this.rating = 0.0,
    List<double>? ratings,
    List<String>? comments,
    this.isFavorite = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<int>? viewsHistory,
    this.recommendScore = 0.0,
  })  : ratings = ratings ?? [],
        comments = comments ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        viewsHistory = viewsHistory ?? List.filled(30, 0);

  /// 🔹 **Convertit l'objet en JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'affiche': affiche,
      'category': category,
      'ownerId': ownerId,
      'duration': duration,
      'views': views,
      'likes': likes,
      'rating': rating,
      'ratings': ratings.map((e) => e.toDouble()).toList(),
      'comments': comments,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'viewsHistory': viewsHistory,
      'recommendScore': recommendScore,
    };
  }

  /// 🔹 **Crée un objet `Film` à partir d’un JSON**
  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      affiche: json['affiche'],
      category: json['category'],
      ownerId: json['ownerId'] ?? "unknown",
      duration: json['duration'] ?? 90,
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      // ✅ Correction de la ligne problématique :
      ratings: json['ratings'] is List
          ? (json['ratings'] as List)
              .whereType<num>()
              .map((e) => e.toDouble())
              .toList()
          : [],
      comments:
          json['comments'] is List ? List<String>.from(json['comments']) : [],
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      viewsHistory: json['viewsHistory'] is List
          ? List<int>.from(json['viewsHistory'])
          : List.filled(30, 0),
      recommendScore: (json['recommendScore'] ?? 0.0).toDouble(),
    );
  }

  get dateAjout => null;
}
