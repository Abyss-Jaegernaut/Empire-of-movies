import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_porn/pages/login.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/film_card.dart';
import '../widgets/side_menu.dart';
import '../widgets/film_search_delegate.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Empire of Movies"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FilmSearchDelegate(filmProvider.films),
              );
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(12),
        child: filmProvider.films.isEmpty
            ? const Center(
                child: Text(
                  "Aucune vidéo disponible",
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
                itemCount: filmProvider.films.length,
                itemBuilder: (context, index) {
                  final film = filmProvider.films[index];
                  return FilmCard(
                    film: film,
                    onLike: () {
                      if (authProvider.currentUser == null) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        filmProvider.likeFilm(film.id);
                      }
                    },
                  );
                },
              ),
      ),
      floatingActionButton: Tooltip(
        message: "Connexion",
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            context.go('/login'); // Redirige vers la page de connexion
          },
          child: const Icon(Icons.login),
        ),
      ),
    );
  }
}
