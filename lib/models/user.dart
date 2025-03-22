import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

enum UserRole { user, moderator, admin, superAdmin }

class AppUser {
  final String id;
  final String username;
  final String email;
  final String hashedPassword;
  final String salt; // ✅ Ajout du sel unique pour chaque utilisateur
  final UserRole role;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.hashedPassword,
    required this.salt, // ✅ Ajout du sel
    this.role = UserRole.user,
  });

  /// 🔹 **Vérifie si un mot de passe correspond au hash enregistré**
  bool verifyPassword(String password) {
    return hashedPassword == _hashPassword(password, salt);
  }

  /// 🔹 **Génère un hash sécurisé d'un mot de passe avec un sel**
  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$password$salt');
    return sha256.convert(bytes).toString();
  }

  /// 🔹 **Génère un sel aléatoire sécurisé**
  static String _generateSalt({int length = 16}) {
    final random = Random.secure();
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// 🔹 **Crée un utilisateur en sécurisant le mot de passe**
  factory AppUser.create({
    required String id,
    required String username,
    required String email,
    required String password,
    UserRole role = UserRole.user,
  }) {
    final salt = _generateSalt(); // ✅ Génère un sel unique
    return AppUser(
      id: id,
      username: username,
      email: email,
      hashedPassword: _hashPassword(password, salt),
      salt: salt, // ✅ Stocke le sel
      role: role,
    );
  }

  /// 🔹 **Convertit l'utilisateur en JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'hashedPassword': hashedPassword,
      'salt': salt,
      'role': role.name,
    };
  }

  /// 🔹 **Crée un utilisateur à partir d'un JSON**
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      hashedPassword: json['hashedPassword'],
      salt: json['salt'],
      role: UserRole.values.firstWhere((r) => r.name == json['role']),
    );
  }

  /// 🔹 **Vérifie si l'utilisateur est Admin ou SuperAdmin**
  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;

  /// 🔹 **Vérifie si l'utilisateur est SuperAdmin**
  bool get isSuperAdmin => role == UserRole.superAdmin;
}
