import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; // ✅ Ajout
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/film_provider.dart';
import 'router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // ✅ Ajout clé pour le Web (enlève le # dans l’URL)

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialisé avec succès !");
  } catch (e) {
    debugPrint("❌ Erreur lors de l'initialisation de Firebase : $e");
  }

  runApp(const EmpireOfMoviesApp());
}

class EmpireOfMoviesApp extends StatelessWidget {
  const EmpireOfMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<FilmProvider>(
          create: (_) => FilmProvider()..fetchFilms(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Empire of Movies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.blueAccent,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintStyle: const TextStyle(color: Colors.white70),
            labelStyle: const TextStyle(color: Colors.white70),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
