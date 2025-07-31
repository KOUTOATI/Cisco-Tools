import 'package:flutter/material.dart';
import 'package:calculator/screens/home_screen.dart';
import 'package:calculator/screens/ip_converter_screen.dart';
import 'package:calculator/screens/eui64_generator_screen.dart';
import 'package:calculator/screens/subnet_calculator_screen.dart'; // Importation du nouvel écran

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Tools',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C3E50), // Sombre comme votre design
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFECF0F1), // Fond clair
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3498DB), // Bleu vif
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/ip_converter': (context) => const IpConverterScreen(),
        '/eui64_generator': (context) => const EUI64GeneratorScreen(),
        '/subnet_calculator': (context) => const SubnetCalculatorScreen(), // Route pour le calculateur de sous-réseaux
      },
    );
  }
}
