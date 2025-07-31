import 'package:flutter/material.dart';
import 'package:calculator/services/ip_utils.dart'; // Importe la classe IpUtils mise à jour
import 'package:calculator/models/ip_models.dart'; // Importe les modèles de données

/// Écran du calculateur de sous-réseaux (Classic et VLSM).
class SubnetCalculatorScreen extends StatefulWidget {
  const SubnetCalculatorScreen({super.key});

  @override
  State<SubnetCalculatorScreen> createState() => _SubnetCalculatorScreenState();
}

class _SubnetCalculatorScreenState extends State<SubnetCalculatorScreen> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _networkAddressController = TextEditingController();
  final TextEditingController _classicSubnetCountController = TextEditingController();

  // Liste pour les besoins VLSM dynamiques
  final List<VLSMRequirementController> _vlsmRequirements = [
    VLSMRequirementController(), // Un champ par défaut
  ];

  // Type de calcul sélectionné (classic ou vlsm)
  String _subnetType = 'classic';

  // Résultats des calculs
  dynamic _calculationResult; // Peut être ClassicSubnetResult ou VLSMResult
  String? _errorMessage; // Message d'erreur à afficher

  @override
  void dispose() {
    _networkAddressController.dispose();
    _classicSubnetCountController.dispose();
    for (var controller in _vlsmRequirements) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Ajoute un nouveau champ de besoin VLSM.
  void _addVLSMRequirement() {
    setState(() {
      _vlsmRequirements.add(VLSMRequirementController());
    });
  }

  /// Supprime un champ de besoin VLSM.
  void _removeVLSMRequirement(int index) {
    setState(() {
      if (_vlsmRequirements.length > 1) { // Ne pas supprimer le dernier
        _vlsmRequirements[index].dispose(); // Libérer les contrôleurs
        _vlsmRequirements.removeAt(index);
      }
    });
  }

  /// Déclenche le calcul du sous-réseau en fonction du type sélectionné.
  void _calculateSubnet() {
    setState(() {
      _calculationResult = null;
      _errorMessage = null;
    });

    try {
      final networkAddress = _networkAddressController.text.trim();

      if (_subnetType == 'classic') {
        final subnetCount = int.tryParse(_classicSubnetCountController.text);
        if (subnetCount == null) {
          throw Exception('Veuillez entrer un nombre de sous-réseaux valide.');
        }
        // Appel à la fonction de calcul classique dans IpUtils
        final result = IpUtils.calculateClassicSubnet(networkAddress, subnetCount);
        setState(() {
          _calculationResult = result;
        });
      } else { // VLSM
        final List<VLSMRequirement> requirements = [];
        for (var controller in _vlsmRequirements) {
          final name = controller.nameController.text.trim();
          final hosts = int.tryParse(controller.hostsController.text);

          if (name.isEmpty || hosts == null || hosts <= 0) {
            throw Exception('Veuillez remplir tous les champs VLSM correctement (Nom et Nb d\'hôtes > 0).');
          }
          requirements.add(VLSMRequirement(name: name, hosts: hosts));
        }
        // Appel à la fonction de calcul VLSM dans IpUtils
        final result = IpUtils.calculateVLSM(networkAddress, requirements);
        setState(() {
          _calculationResult = result;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', ''); // Nettoie le message d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur de Sous-réseaux'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Utilise le thème
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor, // Utilise le thème
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sélecteur de type de sous-réseau
            Card(
              elevation: Theme.of(context).cardTheme.elevation,
              shape: Theme.of(context).cardTheme.shape,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type de Calcul',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _subnetType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'classic', child: Text('Sous-réseautage Classique')),
                        DropdownMenuItem(value: 'vlsm', child: Text('VLSM (Variable Length Subnet Mask)')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _subnetType = value!;
                          _calculationResult = null; // Réinitialiser les résultats
                          _errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Champ d'adresse réseau
            Card(
              elevation: Theme.of(context).cardTheme.elevation,
              shape: Theme.of(context).cardTheme.shape,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Adresse Réseau (ex: 192.168.1.0/24)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _networkAddressController,
                      decoration: InputDecoration(
                        hintText: 'Entrez l\'adresse réseau CIDR',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.network_check),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),

            // Entrées spécifiques au type de calcul
            _subnetType == 'classic'
                ? Card(
                    elevation: Theme.of(context).cardTheme.elevation,
                    shape: Theme.of(context).cardTheme.shape,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nombre de Sous-réseaux (Classique)',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _classicSubnetCountController,
                            decoration: InputDecoration(
                              hintText: 'Entrez le nombre de sous-réseaux',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: const Icon(Icons.numbers),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  )
                : Card(
                    elevation: Theme.of(context).cardTheme.elevation,
                    shape: Theme.of(context).cardTheme.shape,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Besoins VLSM',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: _addVLSMRequirement,
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter un besoin'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Liste des champs de besoins VLSM
                          ..._vlsmRequirements.asMap().entries.map((entry) {
                            int index = entry.key;
                            VLSMRequirementController controller = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller: controller.nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Nom du réseau (ex: LAN Bureau)',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: controller.hostsController,
                                      decoration: InputDecoration(
                                        hintText: 'Nb d\'hôtes',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  if (_vlsmRequirements.length > 1) // Afficher le bouton de suppression si plus d'un champ
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () => _removeVLSMRequirement(index),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

            // Bouton de calcul
            ElevatedButton.icon(
              onPressed: _calculateSubnet,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculer le Sous-réseau'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.blueAccent,
                foregroundColor: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Affichage des erreurs
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade100,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Erreur: $_errorMessage',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // Affichage des résultats
            if (_calculationResult != null)
              _buildResultDisplay(_calculationResult),
          ],
        ),
      ),
    );
  }

  /// Construit l'affichage des résultats en fonction du type de résultat.
  Widget _buildResultDisplay(dynamic result) {
    if (result is ClassicSubnetResult) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: Theme.of(context).cardTheme.elevation,
            shape: Theme.of(context).cardTheme.shape,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résumé du Sous-réseautage Classique',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const Divider(),
                  _buildInfoRow('Réseau Original:', result.originalNetwork),
                  _buildInfoRow('Nouveau Préfixe:', '/${result.newPrefix}'),
                  _buildInfoRow('Bits Empruntés:', '${result.bitsBorrowed}'),
                  _buildInfoRow('Sous-réseaux Créés:', '${result.subnetsCreated}'),
                  _buildInfoRow('Hôtes par Sous-réseau:', '${result.hostsPerSubnet}'),
                ],
              ),
            ),
          ),
          ...result.subnets.map((subnet) => Card(
                elevation: Theme.of(context).cardTheme.elevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subnet.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      _buildInfoRow('Réseau:', subnet.networkAddress),
                      _buildInfoRow('Première Utilisable:', subnet.firstUsableHost),
                      _buildInfoRow('Dernière Utilisable:', subnet.lastUsableHost),
                      _buildInfoRow('Diffusion:', subnet.broadcastAddress),
                      _buildInfoRow('Hôtes Utilisables:', '${subnet.availableHosts}'),
                    ],
                  ),
                ),
              )).toList(),
        ],
      );
    } else if (result is VLSMResult) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: Theme.of(context).cardTheme.elevation,
            shape: Theme.of(context).cardTheme.shape,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résumé VLSM',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const Divider(),
                  _buildInfoRow('Réseau Original:', result.originalNetwork),
                  _buildInfoRow('Sous-réseaux Créés:', '${result.subnetsCreated}'),
                  _buildInfoRow('Adresses Utilisées:', result.usedAddresses.toString()),
                  _buildInfoRow('Adresses Restantes:', result.remainingAddresses.toString()),
                  _buildInfoRow('Efficacité:', '${result.efficiency.toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
          ...result.subnets.map((subnet) => Card(
                elevation: Theme.of(context).cardTheme.elevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subnet.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      _buildInfoRow('Réseau:', subnet.networkAddress),
                      _buildInfoRow('Première Utilisable:', subnet.firstUsableHost),
                      _buildInfoRow('Dernière Utilisable:', subnet.lastUsableHost),
                      _buildInfoRow('Diffusion:', subnet.broadcastAddress),
                      _buildInfoRow('Hôtes Demandés:', '${subnet.requestedHosts}'),
                      _buildInfoRow('Hôtes Disponibles:', '${subnet.availableHosts}'),
                    ],
                  ),
                ),
              )).toList(),
        ],
      );
    }
    return const SizedBox.shrink(); // Ne rien afficher si le résultat est null ou d'un type inattendu
  }

  /// Widget utilitaire pour afficher une ligne d'information.
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

/// Classe utilitaire pour gérer les contrôleurs de texte pour les besoins VLSM.
class VLSMRequirementController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hostsController = TextEditingController();

  void dispose() {
    nameController.dispose();
    hostsController.dispose();
  }
}
