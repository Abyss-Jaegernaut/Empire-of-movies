import 'package:crypto/crypto.dart';
import 'dart:convert';

enum UserRole { user, moderator, admin, superAdmin }

class AppUser {
  final String id;
  final String email;
  final String hashedPassword;
  final UserRole role;

  AppUser({
    required this.id,
    required this.email,
    required this.hashedPassword,
    this.role = UserRole.user,
  });

  // Vérifie si le mot de passe est correct
  bool verifyPassword(String password, String salt) {
    return hashedPassword == hashPassword(password, salt);
  }

  // Méthode statique pour générer le hash sécurisé d'un mot de passe
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode('$password$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Méthode pratique pour créer un utilisateur directement depuis le mot de passe clair
  factory AppUser.create({
    required String id,
    required String email,
    required String password,
    required String salt,
    UserRole role = UserRole.user,
  }) {
    return AppUser(
      id: id,
      email: email,
      hashedPassword: hashPassword(password, salt),
      role: role,
    );
  }
}
