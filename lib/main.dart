import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importe le package provider
import 'package:calculator/screens/ip_converter_screen.dart';
import 'package:calculator/screens/subnet_calculator_screen.dart';
import 'package:calculator/screens/eui64_generator_screen.dart';
import 'package:calculator/screens/dns_lookup_screen.dart';
import 'package:calculator/screens/splash_screen.dart';

// Classe pour gérer l'état du thème
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notifie les widgets écoutant les changements
  }
}

void main() {
  runApp(
    // Utilise ChangeNotifierProvider pour fournir ThemeNotifier à l'arbre de widgets
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(ThemeMode.dark), // Thème par défaut: clair
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Écoute les changements de thème depuis ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Outils Réseau',
      // Utilise le thème actuel de themeNotifier
      themeMode: themeNotifier.themeMode,
      theme: ThemeData( // Thème clair
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        textTheme: TextTheme(
          titleLarge: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          titleMedium: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.blueGrey.shade700),
          bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.black54),
          bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
        ),
        scaffoldBackgroundColor: Colors.white, // Fond de page clair
      ),
      darkTheme: ThemeData( // Nouveau: Thème sombre
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey, // Teinte différente pour le sombre
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          color:  const Color.fromRGBO(29, 25, 152, 0.196), // Couleur de carte sombre
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade900, // Couleur de champ sombre
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        textTheme: TextTheme(
          titleLarge: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          titleMedium: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white70),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.blueGrey.shade200),
          bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.white60),
          bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey.shade400),
        ),
        scaffoldBackgroundColor: Colors.blueGrey.shade900, // Fond de page sombre
      ),
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accède au ThemeNotifier pour basculer le thème
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Outils Réseau'),
        centerTitle: true,
        actions: [
          // Bouton pour basculer le thème
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: themeNotifier.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue dans votre boîte à outils IP !',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.blueAccent : Colors.blueGrey.shade800,
                  ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: <Widget>[
                _buildToolCard(
                  context,
                  icon: Icons.network_check,
                  title: 'Analyseur IP',
                  description: 'Analysez les détails d\'une adresse IPv4/IPv6.',
                  screen: const IpConverterScreen(),
                ),
                _buildToolCard(
                  context,
                  icon: Icons.grid_on,
                  title: 'Calculateur de Sous-réseaux',
                  description: 'Calculez des sous-réseaux classiques ou VLSM.',
                  screen: const SubnetCalculatorScreen(),
                ),
                _buildToolCard(
                  context,
                  icon: Icons.memory,
                  title: 'Générateur EUI-64',
                  description: 'Générez un ID d\'interface EUI-64 à partir d\'une adresse MAC.',
                  screen: const EUI64GeneratorScreen(),
                ),
                _buildToolCard(
                  context,
                  icon: Icons.public,
                  title: 'Recherche DNS',
                  description: 'Trouvez les enregistrements DNS pour un nom de domaine.',
                  screen: const DnsLookupScreen(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Pourquoi utiliser cette application ?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.blueAccent : Colors.blueGrey.shade800,
                  ),
            ),
            const SizedBox(height: 10),
            _buildWhyUseAppItem(
              context,
              icon: Icons.lightbulb_outline,
              text: 'Simplicité : Interface intuitive pour des calculs rapides et efficaces.',
              isDarkMode: isDarkMode,
            ),
            _buildWhyUseAppItem(
              context,
              icon: Icons.speed,
              text: 'Rapidité : Obtenez des résultats instantanés pour vos besoins réseau.',
              isDarkMode: isDarkMode,
            ),
            _buildWhyUseAppItem(
              context,
              icon: Icons.security,
              text: 'Précision : Des calculs fiables pour une gestion réseau sans erreur.',
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 20),
            // Le texte "From Gameli" est maintenant sur le SplashScreen, donc retiré d'ici.
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Widget screen,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: Theme.of(context).cardTheme.elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.blueGrey.shade700,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhyUseAppItem(BuildContext context, {
    required IconData icon,
    required String text,
    required bool isDarkMode, // Pass isDarkMode to helper
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.blueGrey.shade200 : Colors.blueGrey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
