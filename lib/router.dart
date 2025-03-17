import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'models/user.dart';
import 'pages/age_verification.dart';
import 'pages/splash_screen.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/home.dart';
import 'pages/film_details.dart';
import 'pages/admin_dashboard.dart';
import 'pages/add_video.dart';
import 'pages/category_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/age',
    routes: [
      GoRoute(
        path: '/age',
        name: 'age',
        builder: (context, state) => const AgeVerificationPage(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginDialog(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/film/:id',
        name: 'filmDetails',
        builder: (context, state) => FilmDetailsPage(
          filmId: state.pathParameters['id']!,
          movieId: '',
        ),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          if (auth.currentUser == null ||
              auth.currentUser!.role == UserRole.user) {
            return const HomePage();
          }
          return const AdminDashboard();
        },
      ),
      GoRoute(
        path: '/add_video',
        name: 'add_video',
        builder: (context, state) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          if (auth.currentUser == null) {
            return const LoginDialog();
          }
          return const AddVideoPage();
        },
      ),
      GoRoute(
        path: '/category/:name',
        name: 'category',
        builder: (context, state) =>
            CategoryPage(category: state.pathParameters['name']!),
      ),
    ],
  );
}
