import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/film.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<Film>> _filmsFuture;
  late Future<List<Map<String, dynamic>>> _usersFuture;
  bool isSuperAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isSuperAdmin = authProvider.currentUser?.role == UserRole.superAdmin;

    _filmsFuture = ApiService.getAllFilms();
    _usersFuture = ApiService.getAllUsers();
  }

  void _deleteFilm(String filmId) async {
    try {
      await ApiService.deleteFilm(filmId);
      _loadData();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vidéo supprimée avec succès.")),
      );
    } catch (e) {
      _showError(e);
    }
  }

  void _banUser(String userId) async {
    if (!isSuperAdmin) {
      _showError("Vous n'avez pas les droits nécessaires.");
      return;
    }

    try {
      await ApiService.banUser(userId);
      _loadData();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utilisateur banni avec succès.")),
      );
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur : ${e.toString()}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSuperAdmin
            ? "Super Admin Dashboard"
            : "Tableau de bord Administrateur"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _loadData();
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Film>>(
                future: _filmsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return _errorWidget("Erreur lors du chargement des films");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _emptyWidget("Aucun film disponible");
                  }

                  final films = snapshot.data!;
                  return ListView.builder(
                    itemCount: films.length,
                    itemBuilder: (context, index) {
                      final film = films[index];
                      return _filmCard(film);
                    },
                  );
                },
              ),
            ),
            if (isSuperAdmin) _userManagementSection(),
          ],
        ),
      ),
    );
  }

  Widget _filmCard(Film film) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(film.titre,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text("👍 ${film.likes} • 👁️ ${film.views}",
            style: const TextStyle(color: Colors.white70)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _deleteFilm(film.id),
        ),
      ),
    );
  }

  Widget _userManagementSection() {
    return Column(
      children: [
        const Divider(color: Colors.white54),
        const Text(
          "Gestion des utilisateurs",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return _errorWidget(
                    "Erreur lors du chargement des utilisateurs");
              }

              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _userCard(user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _userCard(Map<String, dynamic> user) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title:
            Text(user["username"], style: const TextStyle(color: Colors.white)),
        subtitle:
            Text(user["email"], style: const TextStyle(color: Colors.white54)),
        trailing: user["role"] != "super_admin"
            ? IconButton(
                icon: const Icon(Icons.block, color: Colors.redAccent),
                onPressed: () => _banUser(user["id"]),
              )
            : null,
      ),
    );
  }

  Widget _errorWidget(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _emptyWidget(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}
