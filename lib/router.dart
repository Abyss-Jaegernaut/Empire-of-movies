import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/splash_screen.dart';
import 'pages/age_verification.dart';
import 'pages/home.dart';
import 'pages/add_video.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/category_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/age-verification',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/age-verification',
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
        path: '/add_video',
        builder: (context, state) => const AddVideoPage(),
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
        path: '/categories/:category',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return CategoryPage(category: category);
        },
      ),
    ],
  );
}
