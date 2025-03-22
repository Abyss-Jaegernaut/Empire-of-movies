import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    final bool isAuthenticated = user != null;
    final bool isAdmin = isAuthenticated &&
        (user.role == UserRole.admin || user.role == UserRole.superAdmin);
    final bool isSuperAdmin =
        isAuthenticated && user.role == UserRole.superAdmin;

    return Drawer(
      child: Container(
        color: const Color(0xFF101010),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ✅ En-tête du menu
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Empire of Movies",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isAuthenticated) ...[
                    Text(
                      "👤 ${user.username}",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      "🔹 Rôle: ${_getRoleLabel(user.role)}",
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),

            // ✅ Menu principal
            _buildMenuItem(context, Icons.home, "Accueil", route: "/home"),
            _buildMenuItem(context, Icons.whatshot, "Tendances",
                route: "/categories/tendances"),
            _buildMenuItem(context, Icons.movie, "Films",
                route: "/categories/films"),
            _buildMenuItem(context, Icons.live_tv, "Séries",
                route: "/categories/series"),
            _buildMenuItem(context, Icons.favorite, "Favoris",
                route: "/categories/favorites"),
            const Divider(color: Colors.grey),

            // 🔥 Catégories supplémentaires
            _buildMenuItem(context, Icons.sentiment_very_satisfied, "Comédie",
                route: "/categories/comedie"),
            _buildMenuItem(context, Icons.mood_bad, "Horreur",
                route: "/categories/horreur"),
            _buildMenuItem(context, Icons.theater_comedy, "Drame",
                route: "/categories/drame"),
            _buildMenuItem(context, Icons.science, "Science-Fiction",
                route: "/categories/science-fiction"),
            _buildMenuItem(context, Icons.sports_mma, "Action",
                route: "/categories/action"),
            _buildMenuItem(context, Icons.history_edu, "Historique",
                route: "/categories/historique"),
            _buildMenuItem(context, Icons.child_care, "Animation",
                route: "/categories/animation"),
            _buildMenuItem(context, Icons.music_note, "Musique",
                route: "/categories/musique"),
            _buildMenuItem(context, Icons.emoji_people, "Aventure",
                route: "/categories/aventure"),
            const Divider(color: Colors.grey),

            // ✅ Ajouter du contenu
            if (isAdmin)
              _buildMenuItem(
                  context, Icons.add_circle_outline, "Ajouter une vidéo",
                  route: "/add_video"),

            // ✅ Dashboard admin
            if (isSuperAdmin)
              _buildMenuItem(
                  context, Icons.admin_panel_settings, "Admin Dashboard",
                  route: "/admin_dashboard"),

            const Divider(color: Colors.grey),

            // ✅ Connexion ou déconnexion
            if (isAuthenticated)
              _buildMenuItem(context, Icons.logout, "Se déconnecter",
                  onTap: () async {
                authProvider.logout();
                context.go('/login');
              })
            else
              _buildMenuItem(context, Icons.login, "Se connecter",
                  route: "/login"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    String? route,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) {
          onTap();
        } else if (route != null) {
          context.go(route);
        }
      },
    );
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.user:
        return "Utilisateur";
      case UserRole.admin:
        return "Admin";
      case UserRole.superAdmin:
        return "Super Admin";
      default:
        return "Inconnu";
    }
  }
}
