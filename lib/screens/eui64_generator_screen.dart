import 'package:flutter/material.dart';
import 'package:calculator/models/ip_models.dart';
import 'package:calculator/services/ip_utils.dart';
import 'package:calculator/widgets/result_display.dart';

class EUI64GeneratorScreen extends StatefulWidget {
  const EUI64GeneratorScreen({super.key});

  @override
  State<EUI64GeneratorScreen> createState() => _EUI64GeneratorScreenState();
}

class _EUI64GeneratorScreenState extends State<EUI64GeneratorScreen> {
  final TextEditingController _macController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  bool _includePrefix = false;

  EUI64Result? _result;
  String? _errorMessage;
  bool _isLoading = false;

  void _generateInterfaceId() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    final String macAddress = _macController.text.trim();
    final String ipv6Prefix = _prefixController.text.trim();

    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        if (!IpUtils.validateMACAddress(macAddress)) {
          throw Exception('Format d\'adresse MAC invalide (ex: 00:1A:2B:3C:4D:5E)');
        }

        final result = IpUtils.generateEUI64(
          macAddress,
          ipv6Prefix: _includePrefix ? ipv6Prefix : null,
        );
        setState(() {
          _result = result;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _macController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générateur d\'Interface ID (EUI-64)'),
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
                      'Générez une Interface ID IPv6 (EUI-64) à partir d\'une adresse MAC.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _macController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Adresse MAC',
                        hintText: 'ex: 00:1A:2B:3C:4D:5E',
                        prefixIcon: Icon(Icons.perm_identity),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Checkbox(
                          value: _includePrefix,
                          onChanged: (bool? value) {
                            setState(() {
                              _includePrefix = value ?? false;
                            });
                          },
                        ),
                        const Text('Inclure un préfixe IPv6 pour une adresse complète'),
                      ],
                    ),
                    if (_includePrefix) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _prefixController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Préfixe IPv6',
                          hintText: 'ex: 2001:db8::/64',
                          prefixIcon: Icon(Icons.vpn_key),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _generateInterfaceId,
                      child: const Text('Générer'),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const ResultDisplay(
                results: {},
                title: 'Génération en cours',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ResultDisplay(
                    title: 'Adresse MAC d\'origine',
                    results: {
                      'MAC': _result!.macAddress,
                      'Format binaire': _result!.macBinary,
                    },
                  ),
                  ResultDisplay(
                    title: 'Interface ID EUI-64',
                    results: {
                      'Interface ID': _result!.interfaceId,
                      'Format binaire': _result!.interfaceIdBinary,
                    },
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processus EUI-64',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 20, thickness: 1),
                          SelectableText(
                            _result!.processSteps,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_result!.fullIpv6Address != null)
                    ResultDisplay(
                      title: 'Adresse IPv6 complète',
                      results: {
                        'Préfixe': _result!.ipv6Prefix!,
                        'Interface ID': _result!.interfaceId,
                        'Adresse complète': _result!.fullIpv6Address!,
                        'Format compressé': _result!.compressedIpv6Address!,
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}