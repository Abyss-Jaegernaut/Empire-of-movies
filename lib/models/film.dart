// models/film.dart
class Film {
  final String id;
  final String titre;
  final String description;
  final String affiche;
  final String category;
  int views;
  int likes;
  List<String> comments;

  Film({
    required this.id,
    required this.titre,
    required this.description,
    required this.affiche,
    required this.category,
    this.views = 0,
    this.likes = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}
