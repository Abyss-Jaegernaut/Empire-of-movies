import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/film_provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord Administrateur"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: filmProvider.films.length,
          itemBuilder: (context, index) {
            final film = filmProvider.films[index];
            return Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  film.titre,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "👍 ${film.likes} • 👁️ ${film.views}",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.blueAccent),
                  onPressed: () {
                    filmProvider.deleteFilm(film.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Vidéo supprimée avec succès.")),
                    );
                  },
                ),
                onLongPress: () {
                  // Ajoute ici la logique pour bannir l'utilisateur
                  // Exemple : filmProvider.banUser(film.ownerId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Fonction de bannissement non implémentée.")),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
