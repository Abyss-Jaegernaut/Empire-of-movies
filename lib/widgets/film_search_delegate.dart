import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/film.dart';

class FilmSearchDelegate extends SearchDelegate {
  final List<Film> films;
  Timer? _debounceTimer;

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
    final results = _filterAndSortResults();

    return Container(
      color: Colors.black,
      child: results.isEmpty
          ? const Center(
              child: Text(
                "Aucun film trouvé",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final film = results[index];
                return _buildFilmTile(context, film);
              },
            ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _debounceSearch(context); // ✅ Correction ici
    final suggestions = _filterAndSortResults();

    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final film = suggestions[index];
          return _buildFilmTile(context, film);
        },
      ),
    );
  }

  /// 🔹 **Filtre et trie les résultats par popularité (likes + vues)**
  List<Film> _filterAndSortResults() {
    return films
        .where((film) => film.titre.toLowerCase().contains(query.toLowerCase()))
        .toList()
      ..sort((a, b) => (b.likes + b.views).compareTo(a.likes + a.views));
  }

  /// 🔹 **Retarde l'exécution de la recherche pour éviter de multiples appels inutiles**
  void _debounceSearch(BuildContext context) {
    // ✅ Ajout de BuildContext
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      showSuggestions(context);
    });
  }

  /// 🔹 **Construit un élément de la liste des films**
  Widget _buildFilmTile(BuildContext context, Film film) {
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
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.favorite, color: Colors.redAccent, size: 16),
          const SizedBox(width: 4),
          Text('${film.likes}', style: const TextStyle(color: Colors.white70)),
          const SizedBox(width: 10),
          Icon(Icons.visibility, color: Colors.white54, size: 16),
          const SizedBox(width: 4),
          Text('${film.views}', style: const TextStyle(color: Colors.white70)),
        ],
      ),
      onTap: () {
        close(context, null); // ✅ Ferme la recherche
        context.go('/film/${film.id}');
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
