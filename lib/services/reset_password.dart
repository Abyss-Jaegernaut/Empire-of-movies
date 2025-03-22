import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  final String resetToken; // ✅ Récupération du token de l'email
  const ResetPasswordPage({super.key, required this.resetToken});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String? _message;

  /// 🔹 Fonction pour réinitialiser le mot de passe
  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .resetPasswordWithToken(
        resetToken: widget.resetToken,
        newPassword: _passwordController.text.trim(),
      );

      setState(() {
        _message = "✅ Mot de passe réinitialisé avec succès !";
      });

      Future.delayed(const Duration(seconds: 2), () {
        context.go('/login'); // ✅ Redirection vers la connexion après 2s
      });
    } catch (e) {
      setState(() {
        _message = "❌ Erreur : ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Réinitialiser le mot de passe",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Entrez votre nouveau mot de passe.",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(_passwordController, "Nouveau mot de passe"),
              _buildPasswordField(
                  _confirmPasswordController, "Confirmer le mot de passe"),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Réinitialiser",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              if (_message != null) ...[
                const SizedBox(height: 20),
                Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.startsWith("❌")
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text("Retour à la connexion",
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Widget pour le champ de mot de passe avec validation avancée
  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Veuillez saisir $label";
          if (value.length < 6)
            return "Le mot de passe doit contenir au moins 6 caractères";
          if (controller == _confirmPasswordController &&
              value != _passwordController.text) {
            return "Les mots de passe ne correspondent pas";
          }
          return null;
        },
      ),
    );
  }
}
