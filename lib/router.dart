import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_porn/pages/add_video.dart';
import 'package:my_porn/widgets/side_menu.dart';
import 'pages/splash_screen.dart';
import 'pages/age_verification.dart';
import 'pages/home.dart';
import 'pages/category_page.dart';
import 'pages/login.dart';
import 'pages/register.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/age', // ✅ Vérification de l'âge en premier
    routes: [
      GoRoute(
        path: '/age',
        builder: (context, state) => const AgeVerificationPage(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/category/:name',
        builder: (context, state) =>
            CategoryPage(category: state.pathParameters['name']!),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginDialog(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/SideMenu',
        builder: (context, state) => const SideMenu(),
      ),
      GoRoute(
        path: '/add_video',
        builder: (context, state) => const AddVideoPage(),
      ),
    ],
  );
}
