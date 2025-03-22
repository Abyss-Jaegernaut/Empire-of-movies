import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  UserRole _selectedRole = UserRole.user; // 🏆 Sélection du rôle utilisateur

  /// 🔹 Fonction d'inscription avec validation avancée
  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError("Les mots de passe ne correspondent pas.");
        return;
      }

      setState(() => _isLoading = true);

      try {
        await Provider.of<AuthProvider>(context, listen: false).registerWithAPI(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _selectedRole,
        );

        if (context.mounted) {
          context.go('/home'); // ✅ Redirige après inscription
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 🔹 Fonction pour afficher les erreurs
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Créer un compte",
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildTextField(_usernameController, "Nom d'utilisateur"),
              _buildTextField(_emailController, "Email", isEmail: true),
              _buildPasswordField(_passwordController, "Mot de passe"),
              _buildPasswordField(
                  _confirmPasswordController, "Confirmer le mot de passe",
                  isConfirm: true),

              const SizedBox(height: 10),
              _buildRoleSelection(), // 🔥 Sélection du rôle utilisateur

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("S'inscrire",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/login');
                  }
                },
                child: const Text("Annuler",
                    style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text("Déjà un compte ? Connectez-vous",
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Fonction générique pour créer un champ de texte
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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
          if (isEmail &&
              !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
            return "Veuillez saisir un email valide";
          }
          return null;
        },
      ),
    );
  }

  /// 🔹 Fonction pour créer un champ de mot de passe
  Widget _buildPasswordField(TextEditingController controller, String label,
      {bool isConfirm = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText:
            isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirm
                  ? (_isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off)
                  : (_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                } else {
                  _isPasswordVisible = !_isPasswordVisible;
                }
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez saisir votre mot de passe";
          }
          if (value.length < 6) {
            return "Le mot de passe doit contenir au moins 6 caractères";
          }
          return null;
        },
      ),
    );
  }

  /// 🔹 Sélection du rôle utilisateur
  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sélectionnez votre rôle :",
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        DropdownButtonFormField<UserRole>(
          value: _selectedRole,
          dropdownColor: Colors.black,
          items: UserRole.values.map((role) {
            return DropdownMenuItem<UserRole>(
              value: role,
              child: Text(
                role == UserRole.user
                    ? "Utilisateur"
                    : role == UserRole.admin
                        ? "Administrateur"
                        : "Super Administrateur",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (role) =>
              setState(() => _selectedRole = role ?? UserRole.user),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
