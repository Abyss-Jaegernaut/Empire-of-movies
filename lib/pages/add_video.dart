import 'package:flutter/material.dart';
import 'package:my_porn/models/user.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/film_provider.dart';
import '../providers/auth_provider.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _posterUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false; // ✅ Gestion du chargement

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _posterUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  /// 🔹 Fonction pour ajouter un film via l'API avec AUTH
  void _submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final filmProvider = Provider.of<FilmProvider>(context, listen: false);

    if (authProvider.currentUser == null || authProvider.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⛔ Vous devez être connecté pour ajouter un film.")),
      );
      return;
    }

    // 🔥 Vérifie si l'utilisateur est Admin ou SuperAdmin
    if (authProvider.currentUser?.role != UserRole.admin &&
        authProvider.currentUser?.role != UserRole.superAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⛔ Seuls les Admins peuvent ajouter un film.")),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newFilm = await ApiService.addFilm(
          title: _titleController.text,
          description: _descriptionController.text,
          posterUrl: _posterUrlController.text,
          category: _categoryController.text,
          token: authProvider.token!, // 🔐 Envoie le token JWT
        );

        filmProvider.addFilmToList(
            newFilm); // ✅ Ajoute le film sans recharger tous les films

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Vidéo ajoutée avec succès !")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur : ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un nouveau contenu"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, "Titre"),
              _buildTextField(_descriptionController, "Description",
                  isMultiline: true),
              _buildTextField(_posterUrlController, "URL de l'affiche"),
              _buildTextField(_categoryController, "Catégorie"),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : _submit, // ✅ Désactive le bouton si chargement
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Ajouter le contenu",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  /// 🔹 Fonction générique pour créer un champ de texte
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        maxLines: isMultiline ? 3 : 1,
        validator: (value) =>
            value == null || value.isEmpty ? "Entrez $label" : null,
      ),
    );
  }
}
