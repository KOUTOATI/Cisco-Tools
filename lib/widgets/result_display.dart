import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String title;
  final Map<String, dynamic> results;
  final bool showLoading;
  final bool isError;
  final String? errorMessage;

  const ResultDisplay({
    super.key,
    required this.title,
    required this.results,
    this.showLoading = false,
    this.isError = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(top: 20),
      color: isError ? Colors.red.shade100 : Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isError ? Colors.red.shade800 : Theme.of(context).textTheme.titleLarge?.color,
                  ),
            ),
            const Divider(height: 20, thickness: 1),
            if (showLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (isError && errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              )
            else if (results.isEmpty)
              const Text('Aucun résultat à afficher.')
            else
              ...results.entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120, // Largeur fixe pour les étiquettes
                          child: Text(
                            '${entry.key}:',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: SelectableText(
                            entry.value.toString(),
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
          ],
        ),
      ),
    );
  }
}
