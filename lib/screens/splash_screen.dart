import 'package:flutter/material.dart';
import 'package:calculator/main.dart'; // Importe HomeScreen qui est maintenant dans main.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Après un délai, naviguer vers l'écran d'accueil
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { // Vérifie si le widget est toujours monté avant de naviguer
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 25, 152, 0.196), // CHANGEMENT ICI: Fond blanc
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu verticalement
          children: [
            // CHANGEMENT ICI: Ajout du logo de l'application
            // Remplacez 'assets/images/your_logo.png' par le chemin réel de votre image de logo.
            // Assurez-vous d'avoir ajouté votre dossier 'assets/images/' dans pubspec.yaml
            Image.asset(
              'assets/images/logo.png', // Placeholder pour le logo
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.apps, size: 100, color: Colors.blueAccent); // Fallback icon
              },
            ),
            const SizedBox(height: 300), // Espace entre le logo et le texte

            // Le texte "From Gameli" est maintenant au centre de l'écran avec le logo
            Text(
              'From Gameli',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blueGrey, // CHANGEMENT ICI: Texte noir sur fond blanc
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
