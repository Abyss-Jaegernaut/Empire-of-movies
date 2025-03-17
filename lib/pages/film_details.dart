import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';
import '../models/film.dart';

class FilmDetailsPage extends StatefulWidget {
  final String movieId;
  const FilmDetailsPage({super.key, required this.movieId, required filmId});

  @override
  State<FilmDetailsPage> createState() => _FilmDetailsPageState();
}

class _FilmDetailsPageState extends State<FilmDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  void _submitComment(FilmProvider filmProvider, String movieId) {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      // Ici, assurez-vous que votre FilmProvider attend un paramètre nommé "movieId"
      filmProvider.addComment(movieId: movieId, comment: comment);
      _commentController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    // Utiliser addPostFrameCallback pour éviter d'utiliser le context directement dans initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FilmProvider>(context, listen: false)
          .incrementViewCount(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    // Supposons que filmProvider.films soit une List<Film> non nullable.
    final Film film = filmProvider.films.firstWhere(
      (film) => film.id == widget.movieId,
      orElse: () => throw Exception('Film introuvable'),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(film.titre, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                  icon: const Icon(Icons.favorite_border),
                  label: const Text("J'aime"),
                  onPressed: () {
                    Provider.of<FilmProvider>(context, listen: false)
                        .likeFilm(film.id);
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
            ...film.comments.map((comment) => ListTile(
                  leading: const Icon(Icons.comment, color: Colors.white54),
                  title: Text(comment,
                      style: const TextStyle(color: Colors.white70)),
                )),
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
              // On passe filmProvider et widget.movieId ici
              onPressed: () => _submitComment(filmProvider, widget.movieId),
              child: const Text("Ajouter un commentaire"),
            ),
          ],
        ),
      ),
    );
  }
}
