import 'package:flutter/material.dart';
import 'package:calculator/models/ip_models.dart';
import 'package:calculator/services/ip_utils.dart';
import 'package:calculator/widgets/result_display.dart';

class IpConverterScreen extends StatefulWidget {
  const IpConverterScreen({super.key});

  @override
  State<IpConverterScreen> createState() => _IpConverterScreenState();
}

class _IpConverterScreenState extends State<IpConverterScreen> {
  final TextEditingController _ipCidrController = TextEditingController();
  String _selectedIpVersion = 'IPv4'; // Défaut à IPv4
  IpAnalysisResult? _result;
  String? _errorMessage;
  bool _isLoading = false;

  void _analyzeIpAddress() {
    debugPrint('_analyzeIpAddress called');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    final String ipCidr = _ipCidrController.text.trim();
    debugPrint('Input IP/CIDR: "$ipCidr", Version: $_selectedIpVersion');

    Future.microtask(() {
      try {
        final result = IpUtils.analyzeIp(ipCidr, _selectedIpVersion);
        debugPrint('Analysis successful. Result IP: ${result.ipAddress}');
        setState(() {
          _result = result;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('Analysis failed. Error: $e');
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _ipCidrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('IpConverterScreen build method called. _result: $_result, _errorMessage: $_errorMessage, _isLoading: $_isLoading');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertisseur IP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysez une adresse IP (IPv4 ou IPv6) avec son masque de sous-réseau.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedIpVersion,
                      decoration: const InputDecoration(
                        labelText: 'Type d\'adresse IP',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: <String>['IPv4', 'IPv6']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedIpVersion = newValue!;
                          _result = null; // Réinitialiser les résultats lors du changement de type
                          _errorMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _ipCidrController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Entrez une adresse IP avec préfixe CIDR',
                        hintText: _selectedIpVersion == 'IPv4'
                            ? 'ex: 172.158.1.0/24'
                            : 'ex: 2001:db8:abcd::1/64',
                        prefixIcon: const Icon(Icons.network_check),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _analyzeIpAddress,
                      child: const Text('Analyser'),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const ResultDisplay(
                results: {},
                title: 'Analyse en cours',
                showLoading: true,
              ),
            if (_errorMessage != null)
              ResultDisplay(
                results: {},
                title: 'Erreur',
                isError: true,
                errorMessage: _errorMessage,
              ),
            if (_result != null)
              _result!.ipVersion == 'IPv4'
                  ? ResultDisplay(
                      title: 'Résultats de l\'analyse IPv4',
                      results: {
                        'Adresse IP CIDR': _result!.originalIpCidr,
                        'Adresse IP': _result!.ipAddress,
                        'Longueur du préfixe': _result!.prefixLength,
                        'IP Binaire': _result!.ipBinary,
                        'Masque de sous-réseau': _result!.subnetMask!,
                        'Masque Binaire': _result!.subnetMaskBinary!,
                        'Adresse Réseau': _result!.networkAddress!,
                        'Réseau Binaire': _result!.networkAddressBinary!,
                        'Adresse de diffusion': _result!.broadcastAddress!,
                        'Diffusion Binaire': _result!.broadcastAddressBinary!,
                        'Première hôte utilisable': _result!.firstHost!,
                        'Dernière hôte utilisable': _result!.lastHost!,
                        'Nombre total d\'hôtes': _result!.totalHosts.toString(),
                      },
                    )
                  : ResultDisplay(
                      title: 'Résultats de l\'analyse IPv6',
                      results: {
                        'Adresse IP CIDR': _result!.originalIpCidr,
                        'Adresse IP': _result!.ipAddress,
                        'Longueur du préfixe': _result!.prefixLength,
                        'IP Binaire': _result!.ipBinary,
                        'IPv6 Étendue': _result!.expandedIpv6!,
                        'IPv6 Compressée': _result!.compressedIpv6!,
                        // Nouveaux champs pour IPv6, affichés même s'ils sont null (avec 'N/A')
                        'Adresse Réseau IPv6': _result!.networkAddressIPv6 ?? 'N/A',
                        'Première Adresse Utilisable': _result!.firstUsableIPv6 ?? 'N/A',
                        'Dernière Adresse Utilisable': _result!.lastUsableIPv6 ?? 'N/A',
                        'Nombre Total d\'Adresses': _result!.totalAddressesIPv6 ?? 'N/A',
                      },
                    ),
          ],
        ),
      ),
    );
  }
}
