import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  String? _token;
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _hasValidatedAge = false;
  bool get hasValidatedAge => _hasValidatedAge;

  AuthProvider()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://192.168.1.14:5000/api",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {"Content-Type": "application/json"},
        )) {
    _loadUserFromStorage();
  }

  AppUser? get currentUser => _currentUser;
  String? get token => _token;

  Future<void> _loadUserFromStorage() async {
    try {
      _token = await _storage.read(key: "token");
      String? ageValue = await _storage.read(key: "hasValidatedAge");
      _hasValidatedAge = ageValue == "true";

      if (_token != null) {
        _dio.options.headers["Authorization"] = "Bearer $_token";
        await _fetchCurrentUser();
      }

      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Erreur lors du chargement du token : $e");
    }
  }

  Future<void> validateAge() async {
    _hasValidatedAge = true;
    await _storage.write(key: "hasValidatedAge", value: "true");
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post("/auth/login", data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        _token = response.data["token"];
        await _storage.write(key: "token", value: _token);
        _dio.options.headers["Authorization"] = "Bearer $_token";

        await _fetchCurrentUser();
        notifyListeners();
      } else {
        throw Exception("Échec de la connexion.");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Erreur de connexion.");
    }
  }

  Future<void> logoutUser() async {
    try {
      _currentUser = null;
      _token = null;
      _dio.options.headers.remove("Authorization");

      await _storage.delete(key: "token");
      await _storage.delete(key: "hasValidatedAge");

      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Erreur lors de la déconnexion : $e");
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final response = await _dio.post("/auth/register", data: {
        "username": username,
        "email": email,
        "password": password,
      });

      if (response.statusCode == 201) {
        _token = response.data["token"];
        await _storage.write(key: "token", value: _token);
        _dio.options.headers["Authorization"] = "Bearer $_token";

        await _fetchCurrentUser();
        notifyListeners();
      } else {
        throw Exception("Échec de l'inscription.");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Erreur lors de l'inscription.");
    }
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final response = await _dio.get("/auth/me");

      if (response.statusCode == 200) {
        _currentUser = AppUser(
          id: response.data["id"],
          username: response.data["username"],
          email: response.data["email"],
          hashedPassword: "",
          role: _getUserRole(response.data["role"]),
          salt: '',
        );
        notifyListeners();
      }
    } on DioException catch (e) {
      debugPrint("⚠️ Erreur de récupération du profil : ${e.response?.data}");

      if (e.response?.statusCode == 401) {
        await logoutUser();
      }
    }
  }

  UserRole _getUserRole(String role) {
    switch (role) {
      case "super_admin":
        return UserRole.superAdmin;
      case "admin":
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }

  Future<void> updateUserProfile(String username, String email) async {
    try {
      final response = await _dio.put("/auth/update-profile", data: {
        "username": username,
        "email": email,
      });

      if (response.statusCode == 200) {
        _currentUser = AppUser(
          id: _currentUser!.id,
          username: username,
          email: email,
          hashedPassword: "",
          role: _currentUser!.role,
          salt: '',
        );
        notifyListeners();
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ??
          "Erreur lors de la mise à jour du profil.");
    }
  }

  Future<void> refreshToken() async {
    try {
      final response = await _dio.post("/auth/refresh-token");

      if (response.statusCode == 200) {
        _token = response.data["token"];
        await _storage.write(key: "token", value: _token);
        _dio.options.headers["Authorization"] = "Bearer $_token";
        notifyListeners();
      } else {
        await logoutUser();
      }
    } on DioException catch (e) {
      await logoutUser();
      throw Exception(e.response?.data["message"] ??
          "Erreur lors du rafraîchissement du token.");
    }
  }

  Future<void> resetPassword(
      {required String email, required String newPassword}) async {
    try {
      final response = await _dio.post("/auth/reset-password", data: {
        "email": email,
        "newPassword": newPassword,
      });

      if (response.statusCode != 200) {
        throw Exception("Échec de la réinitialisation.");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Erreur de réinitialisation.");
    }
  }

  bool get isAdmin =>
      _currentUser?.role == UserRole.admin ||
      _currentUser?.role == UserRole.superAdmin;

  bool get isSuperAdmin => _currentUser?.role == UserRole.superAdmin;

  registerWithAPI(
      String trim, String trim2, String text, UserRole selectedRole) {}

  resetPasswordWithToken(
      {required String resetToken, required String newPassword}) {}

  void logout() {}
}
