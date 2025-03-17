import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;

  final Map<String, AppUser> _userDatabase = {};
  final _uuid = Uuid();

  AppUser? get currentUser => _currentUser;
  Map<String, AppUser> get userDatabase => _userDatabase;

  void login(String email, String password) {
    if (!_userDatabase.containsKey(email)) {
      throw Exception("Email non enregistré.");
    }

    final user = _userDatabase[email]!;
    if (!user.verifyPassword(password, email)) {
      throw Exception("Mot de passe incorrect.");
    }

    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void register(String email, String password) {
    if (_userDatabase.containsKey(email)) {
      throw Exception("Cet email est déjà utilisé.");
    }

    final newUser = AppUser.create(
      id: _uuid.v4(),
      email: email,
      password: password,
      salt: email,
      role: UserRole.user,
    );

    _userDatabase[email] = newUser;
    _currentUser = newUser;
    notifyListeners();
  }

  void createAdminAccount({
    required String email,
    required String password,
    required UserRole role,
  }) {
    if (role != UserRole.admin && role != UserRole.moderator) {
      throw Exception("Le rôle doit être admin ou modérateur.");
    }

    if (_userDatabase.containsKey(email)) {
      throw Exception("Cet email est déjà utilisé.");
    }

    final newAdmin = AppUser.create(
      id: _uuid.v4(),
      email: email,
      password: password,
      salt: email,
      role: role,
    );

    _userDatabase[email] = newAdmin;
    notifyListeners();
  }

  void resetPassword({required String email, required String newPassword}) {
    if (!_userDatabase.containsKey(email)) {
      throw Exception("Email non trouvé.");
    }
    final user = _userDatabase[email]!;
    final updatedUser = AppUser(
      id: user.id,
      email: email,
      hashedPassword: AppUser.hashPassword(newPassword, email),
      role: userDatabase[email]!.role,
    );
    _userDatabase[email] = updatedUser;

    if (_currentUser?.email == email) {
      _currentUser = updatedUser;
    }

    notifyListeners();
  }

  id(String text, String text2) {}
}
