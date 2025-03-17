import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_porn/models/film.dart';

class FilmCard extends StatelessWidget {
  final Film film;
  final VoidCallback onLike;

  const FilmCard({
    Key? key,
    required this.film,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/film/${film.id}'),
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.blueAccent, size: 16),
                      const SizedBox(width: 4),
                      Text('${film.likes}',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 10),
                      Icon(Icons.visibility, color: Colors.white54, size: 16),
                      const SizedBox(width: 4),
                      Text('${film.views}',
                          style: TextStyle(color: Colors.white70)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined,
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
}
