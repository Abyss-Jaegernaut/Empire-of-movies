import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_porn/models/film.dart';

class FilmSearchDelegate extends SearchDelegate {
  final List<Film> films;

  FilmSearchDelegate(this.films);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white70),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white70),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = films
        .where((film) => film.titre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final film = results[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                film.affiche,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              film.titre,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              film.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () => context.go('/film/${film.id}'),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = films
        .where((film) => film.titre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final film = suggestions[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                film.affiche,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              film.titre,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              query = film.titre;
              showResults(context);
            },
          );
        },
      ),
    );
  }
}
