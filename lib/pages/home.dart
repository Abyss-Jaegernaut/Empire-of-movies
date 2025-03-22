import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';
import '../widgets/film_card.dart';
import '../widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sortOrder = "populaire"; // 📊 Critère de tri sélectionné

  @override
  void initState() {
    super.initState();
    // ⚠️ Important : attendre que le build soit prêt pour accéder au provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FilmProvider>(context, listen: false).fetchFilms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    List films = [
      ...filmProvider.films
    ]; // 🧪 Copie pour éviter de modifier l’original

    // 🔹 Appliquer le tri selon l’option sélectionnée
    if (_sortOrder == "populaire") {
      films.sort((a, b) => (b.likes + b.views).compareTo(a.likes + a.views));
    } else if (_sortOrder == "récent") {
      films.sort((a, b) => b.dateAjout.compareTo(a.dateAjout));
    } else if (_sortOrder == "favoris") {
      films = films.where((film) => filmProvider.isFavorite(film.id)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Empire of Movies"),
        backgroundColor: Colors.black,
        actions: [
          // 🔄 Rafraîchir les films
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => filmProvider.fetchFilms(),
          ),
          // 🔽 Menu de tri
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (value) => setState(() => _sortOrder = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "populaire",
                child: Text("Trier par popularité"),
              ),
              const PopupMenuItem(
                value: "récent",
                child: Text("Trier par plus récent"),
              ),
              const PopupMenuItem(
                value: "favoris",
                child: Text("Voir mes favoris"),
              ),
            ],
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: filmProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : films.isEmpty
              ? const Center(
                  child: Text(
                    "Aucun film disponible",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: films.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final film = films[index];
                      return FilmCard(
                        film: film,
                        onLike: () async {
                          await filmProvider.likeFilm(film.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("👍 Film ajouté aux favoris !"),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
