import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';
import '../models/film.dart';
import '../widgets/film_card.dart';
import '../widgets/film_search_delegate.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);

    final List<Film> filteredFilms = filmProvider.films
        .whereType<Film>()
        .where((film) => film.category.toLowerCase() == category.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName('/home')),
        ),
        title: Text(category),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FilmSearchDelegate(filteredFilms),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(12),
        child: filteredFilms.isEmpty
            ? const Center(
                child: Text(
                  "Aucun contenu disponible pour cette catégorie.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredFilms.length,
                itemBuilder: (context, index) {
                  final film = filteredFilms[index];
                  return FilmCard(
                    film: film,
                    onLike: () => filmProvider.likeFilm(film.id),
                  );
                },
              ),
      ),
    );
  }
}
