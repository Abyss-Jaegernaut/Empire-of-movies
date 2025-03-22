import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';
import '../providers/auth_provider.dart';
import '../models/film.dart';

class FilmDetailsPage extends StatefulWidget {
  final String movieId;
  const FilmDetailsPage({super.key, required this.movieId});

  @override
  State<FilmDetailsPage> createState() => _FilmDetailsPageState();
}

class _FilmDetailsPageState extends State<FilmDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isFavorite = false; // ✅ Gestion des favoris

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filmProvider = Provider.of<FilmProvider>(context, listen: false);
      filmProvider.incrementViewCount(widget.movieId);
      _isFavorite = filmProvider.isFavorite(widget.movieId);
    });
  }

  void _toggleFavorite() {
    final filmProvider = Provider.of<FilmProvider>(context, listen: false);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      filmProvider.addToFavorites(widget.movieId);
    } else {
      filmProvider.removeFromFavorites(widget.movieId);
    }
  }

  void _submitComment(FilmProvider filmProvider, String movieId) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⛔ Connectez-vous pour commenter.")),
      );
      return;
    }

    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      filmProvider.addComment(movieId: movieId, comment: comment);
      _commentController.clear();
    }
  }

  void _deleteComment(FilmProvider filmProvider, String movieId, int index) {
    filmProvider.deleteComment(movieId: movieId, commentIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    final Film film = filmProvider.films.firstWhere(
      (film) => film.id == widget.movieId,
      orElse: () => throw Exception('Film introuvable'),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(film.titre, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border,
                color: Colors.yellow),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(film.affiche, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              film.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.remove_red_eye, color: Colors.grey[400]),
                const SizedBox(width: 6),
                Text("${film.views}",
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(width: 20),
                Icon(Icons.favorite, color: Colors.blueAccent),
                const SizedBox(width: 6),
                Text("${film.likes}",
                    style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  label: const Text("J'aime"),
                  onPressed: () {
                    filmProvider.likeFilm(film.id);
                  },
                ),
              ],
            ),
            const Divider(height: 30, color: Colors.white38),
            const Text(
              "Commentaires",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...film.comments.asMap().entries.map((entry) {
              int index = entry.key;
              String comment = entry.value;
              return ListTile(
                leading: const Icon(Icons.comment, color: Colors.white54),
                title: Text(comment,
                    style: const TextStyle(color: Colors.white70)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteComment(filmProvider, film.id, index),
                ),
              );
            }),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ajouter un commentaire...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _submitComment(filmProvider, film.id),
              child: const Text("Ajouter un commentaire"),
            ),
          ],
        ),
      ),
    );
  }
}
