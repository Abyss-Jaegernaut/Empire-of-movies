import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';
import '../models/film.dart';
import '../widgets/film_card.dart';
import '../widgets/film_search_delegate.dart';
import '../widgets/side_menu.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _sortOrder = "popularité"; // 📊 Critère de tri

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);

    // ✅ Vérifie si c'est la catégorie "favoris"
    List<Film> filteredFilms = (widget.category.toLowerCase() == "favorites")
        ? filmProvider.favoriteFilms // ✅ Utilise les films favoris
        : filmProvider.films
            .where((film) =>
                film.category.toLowerCase() == widget.category.toLowerCase())
            .toList();

    // 🔹 Trier les films selon le critère sélectionné
    if (_sortOrder == "popularité") {
      filteredFilms
          .sort((a, b) => (b.likes + b.views).compareTo(a.likes + a.views));
    } else if (_sortOrder == "récent") {
      filteredFilms.sort((a, b) => b.dateAjout.compareTo(a.dateAjout));
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.category == "favorites" ? "Favoris" : widget.category),
        backgroundColor: Colors.black,
        actions: [
          // 🔍 Recherche
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FilmSearchDelegate(filteredFilms),
              );
            },
          ),
          // 🔽 Trier les films
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (value) => setState(() => _sortOrder = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: "popularité", child: Text("Trier par popularité")),
              const PopupMenuItem(
                  value: "récent", child: Text("Trier par plus récent")),
            ],
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: filteredFilms.isEmpty
          ? const Center(
              child: Text(
                "Aucun film trouvé dans cette catégorie.",
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
                return FilmCard(film: filteredFilms[index], onLike: () {});
              },
            ),
    );
  }
}
