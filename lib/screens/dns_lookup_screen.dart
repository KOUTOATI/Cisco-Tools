import 'package:flutter/material.dart';
import 'package:calculator/models/ip_models.dart';
import 'package:calculator/services/dns_utils.dart';
import 'package:calculator/widgets/result_display.dart'; // Assurez-vous que ce widget existe

class DnsLookupScreen extends StatefulWidget {
  const DnsLookupScreen({super.key});

  @override
  State<DnsLookupScreen> createState() => _DnsLookupScreenState();
}

class _DnsLookupScreenState extends State<DnsLookupScreen> {
  final TextEditingController _domainController = TextEditingController();
  DnsLookupResult? _result;
  String? _errorMessage;
  bool _isLoading = false;

  void _performDnsLookup() async {
    debugPrint('_performDnsLookup called');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    final String domainName = _domainController.text.trim();
    if (domainName.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un nom de domaine.';
        _isLoading = false;
      });
      return;
    }

    try {
      final lookupResult = await DnsUtils.lookupDns(domainName);
      debugPrint('DNS Lookup successful for ${lookupResult.domainName}');
      setState(() {
        _result = lookupResult;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('DNS Lookup failed. Error: $e');
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DnsLookupScreen build method called. _result: $_result, _errorMessage: $_errorMessage, _isLoading: $_isLoading');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche DNS'),
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
                      'Recherchez les enregistrements DNS pour un nom de domaine.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _domainController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Entrez un nom de domaine',
                        hintText: 'ex: google.com ou github.com',
                        prefixIcon: Icon(Icons.public),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _performDnsLookup,
                      child: const Text('Rechercher DNS'),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const ResultDisplay(
                results: {},
                title: 'Recherche en cours',
                showLoading: true,
              ),
            if (_errorMessage != null)
              ResultDisplay(
                results: {},
                title: 'Erreur',
                isError: true,
                errorMessage: _errorMessage,
              ),
            if (_result != null && _result!.isSuccess)
              ResultDisplay(
                title: 'Résultats DNS pour ${_result!.domainName}',
                results: {
                  for (var record in _result!.records)
                    '${record.type.name}': record.value + (record.ttl != null ? ' (TTL: ${record.ttl}s)' : ''),
                },
              ),
            if (_result != null && !_result!.isSuccess && _result!.errorMessage != null)
              ResultDisplay(
                results: {},
                title: 'Échec de la recherche DNS',
                isError: true,
                errorMessage: _result!.errorMessage,
              ),
          ],
        ),
      ),
    );
  }
}
