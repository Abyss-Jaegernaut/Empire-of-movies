import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/film.dart';
import '../providers/film_provider.dart';

class FilmCard extends StatelessWidget {
  final Film film;
  final VoidCallback onLike;

  const FilmCard({
    super.key, // ✅ Correction du super paramètre
    required this.film,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    final bool isFavorite = filmProvider.isFavorite(film.id);

    return GestureDetector(
      onTap: () => context.go('/film/${film.id}'),
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // ✅ Image du film
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    film.affiche,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // ⭐ Bouton Favoris
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => filmProvider.toggleFavorite(
                        film.id, context), // ✅ Ajout du contexte si nécessaire
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isFavorite),
                        color: isFavorite ? Colors.redAccent : Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎬 Titre du film
                  Text(
                    film.titre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // 👍 Likes et 👀 Vues
                  Row(
                    children: [
                      _buildIconText(
                          Icons.favorite, '${film.likes}', Colors.blueAccent),
                      const SizedBox(width: 10),
                      _buildIconText(
                          Icons.visibility, '${film.views}', Colors.white54),
                      const Spacer(),
                      // 🖤 Bouton "J'aime"
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined,
                            color: Colors.blueAccent),
                        onPressed: onLike,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget pour afficher une icône avec un texte (ex: Vues et Likes)
  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}
