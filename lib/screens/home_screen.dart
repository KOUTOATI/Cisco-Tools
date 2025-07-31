import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Tools Suite'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue dans votre boîte à outils IP !',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Deux colonnes
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  // Carte pour le Convertisseur IP
                  _buildToolCard(
                    context,
                    icon: Icons.compare_arrows,
                    title: 'Convertisseur IP',
                    description: 'Convertir entre IPv4 et IPv6.',
                    onTap: () {
                      Navigator.pushNamed(context, '/ip_converter');
                    },
                  ),
                  // Carte pour le Calculateur de Sous-réseaux (VLSM)
                  _buildToolCard(
                    context,
                    icon: Icons.grid_on, // Ou Icons.layers
                    title: 'Calculateur de Sous-réseaux (VLSM)',
                    description: 'Calculer les sous-réseaux avec VLSM.',
                    onTap: () {
                      // Navigue vers le nouvel écran du calculateur de sous-réseaux
                      Navigator.pushNamed(context, '/subnet_calculator');
                    },
                  ),
                  // Carte pour le Générateur EUI-64
                  _buildToolCard(
                    context,
                    icon: Icons.settings_ethernet,
                    title: 'Générateur d\'Interface ID (EUI-64)',
                    description: 'Générer une Interface ID EUI-64 à partir d\'une MAC.',
                    onTap: () {
                      Navigator.pushNamed(context, '/eui64_generator');
                    },
                  ),
                  // Vous pouvez ajouter d'autres cartes ici
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Pourquoi utiliser cette application ?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
            ),
            const SizedBox(height: 10),
            // Section "Simplicité"
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Simplicité : Interface intuitive pour des calculs rapides et efficaces.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            // Assurez-vous que cette ligne est supprimée si elle est encore présente
            // Text('VLSM Calculator à venir prochainement !', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: Theme.of(context).cardTheme.elevation,
      shape: Theme.of(context).cardTheme.shape,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
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
                      color: Colors.blueGrey.shade700,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
