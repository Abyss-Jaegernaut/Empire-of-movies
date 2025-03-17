import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgeVerificationPage extends StatelessWidget {
  const AgeVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Avertissement",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Cette plateforme contient du contenu violent ou à caractère sexuel explicite réservé à un public adulte. Veuillez confirmer que vous êtes majeur (18 ans ou plus) pour accéder au contenu.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () => context.go('/splash'),
              child: const Text(
                "J'ai 18 ans ou plus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Accès refusé : réservé aux adultes uniquement.",
                    ),
                  ),
                );
              },
              child: const Text(
                "Je n'ai pas encore 18 ans",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
