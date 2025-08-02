import 'package:flutter/material.dart';
import 'package:calculator/screens/ip_converter_screen.dart';
import 'package:calculator/screens/subnet_calculator_screen.dart'; // Assurez-vous que ce fichier existe
import 'package:calculator/screens/eui64_generator_screen.dart'; // Assurez-vous que ce fichier existe
import 'package:calculator/screens/dns_lookup_screen.dart'; // Nouveau: Importe l'écran de recherche DNS

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outils Réseau',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
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
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outils Réseau'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Deux colonnes
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildToolCard(
              context,
              'Analyseur IP',
              'Analysez les détails d\'une adresse IPv4/IPv6.',
              Icons.network_check,
              const IpConverterScreen(),
            ),
            _buildToolCard(
              context,
              'Calculateur de Sous-réseaux',
              'Calculez des sous-réseaux classiques ou VLSM.',
              Icons.grid_on,
              const SubnetCalculatorScreen(),
            ),
            _buildToolCard(
              context,
              'Générateur EUI-64',
              'Générez un ID d\'interface EUI-64 à partir d\'une adresse MAC.',
              Icons.memory,
              const EUI64GeneratorScreen(),
            ),
            _buildToolCard( // Nouveau: Carte pour la recherche DNS
              context,
              'Recherche DNS',
              'Trouvez les enregistrements DNS pour un nom de domaine.',
              Icons.public,
              const DnsLookupScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String description, IconData icon, Widget screen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
