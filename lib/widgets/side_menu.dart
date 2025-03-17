import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/film_provider.dart';
import '../providers/auth_provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filmProvider = Provider.of<FilmProvider>(context);
    Provider.of<AuthProvider>(context);

    return Drawer(
      child: Container(
        color: const Color(0xFF101010),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text(
                "Empire of Movies",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white70),
              title: const Text("Accueil",
                  style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            _buildMenuItem(context, Icons.whatshot, "Tendances",
                route: "/category/tendances"),
            _buildMenuItem(context, Icons.movie, "Films",
                route: "/category/films"),
            _buildMenuItem(context, Icons.live_tv, "Séries",
                route: "/category/series"),
            _buildMenuItem(context, Icons.theaters, "Courts-métrages",
                trailing: "BETA", route: "/category/courts-metrages"),
            _buildMenuItem(context, Icons.thumb_up, "Recommandations",
                route: "/category/recommandations"),
            const Divider(color: Colors.grey),
            _buildMenuItem(context, Icons.explore, "Action",
                route: "/category/action"),
            _buildMenuItem(context, Icons.favorite, "Romance",
                route: "/category/romance"),
            _buildMenuItem(context, Icons.mood, "Comédie",
                route: "/category/comedie"),
            _buildMenuItem(context, Icons.science, "Science-fiction",
                route: "/category/science-fiction"),
            _buildMenuItem(context, Icons.auto_stories, "Anime",
                route: "/category/anime"),
            const Divider(color: Colors.grey),
            if (filmProvider.trendingCategories.isNotEmpty)
              ...filmProvider.trendingCategories.map((cat) => _buildMenuItem(
                    context,
                    Icons.trending_up,
                    cat,
                    route: "/category/$cat",
                  )),
            const Divider(color: Colors.grey),
            ListTile(
              leading:
                  const Icon(Icons.add_circle_outline, color: Colors.white),
              title: const Text("Ajouter du contenu",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                context.go("/add_video");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {String? trailing, String? route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      trailing: trailing != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(trailing,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        if (route != null) {
          context.go(route);
        } else {
          context.go('/home');
        }
      },
    );
  }
}
