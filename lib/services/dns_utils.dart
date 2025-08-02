import 'package:flutter/material.dart';
import 'package:calculator/models/ip_models.dart';
// import 'dart:io'; // Pour les requêtes DNS réelles sur les plateformes natives

class DnsUtils {
  /// Effectue une recherche DNS pour le nom de domaine donné.
  ///
  /// Dans un environnement Flutter Web (Canvas), les requêtes DNS directes
  /// ne sont pas possibles pour des raisons de sécurité du navigateur.
  /// Cette implémentation simule une recherche pour démontrer la structure.
  ///
  /// Pour une application Flutter native (Android, iOS, Desktop), vous utiliseriez
  /// `dart:io` pour effectuer de véritables requêtes DNS.
  static Future<DnsLookupResult> lookupDns(String domainName) async {
    debugPrint('DnsUtils.lookupDns called for: $domainName');
    List<DnsRecord> records = [];
    String? errorMessage;

    // Simulation de la recherche DNS pour l'environnement web (Canvas)
    // Dans une application native, vous utiliseriez quelque chose comme :
    // try {
    //   final addresses = await InternetAddress.lookup(domainName);
    //   for (var addr in addresses) {
    //     if (addr.type == InternetAddressType.IPv4) {
    //       records.add(DnsRecord(type: DnsRecordType.A, value: addr.address));
    //     } else if (addr.type == InternetAddressType.IPv6) {
    //       records.add(DnsRecord(type: DnsRecordType.AAAA, value: addr.address));
    //     }
    //   }
    //   // Pour d'autres types d'enregistrements (MX, NS, TXT), vous auriez besoin
    //   // d'une bibliothèque tierce ou d'une API externe.
    // } on SocketException catch (e) {
    //   errorMessage = 'Erreur de recherche DNS: ${e.message}';
    //   debugPrint('DNS Lookup Error: $e');
    // }

    // Simulation de données pour quelques domaines courants
    switch (domainName.toLowerCase()) {
      case 'google.com':
        records.add(DnsRecord(type: DnsRecordType.A, value: '142.250.186.142', ttl: 300));
        records.add(DnsRecord(type: DnsRecordType.AAAA, value: '2a00:1450:4007:80f::200e', ttl: 300));
        records.add(DnsRecord(type: DnsRecordType.MX, value: 'smtp.google.com', ttl: 3600));
        records.add(DnsRecord(type: DnsRecordType.TXT, value: 'v=spf1 include:_spf.google.com ~all', ttl: 3600));
        break;
      case 'github.com':
        records.add(DnsRecord(type: DnsRecordType.A, value: '140.82.112.4', ttl: 60));
        records.add(DnsRecord(type: DnsRecordType.AAAA, value: '2606:50c0:8000::153', ttl: 60));
        records.add(DnsRecord(type: DnsRecordType.NS, value: 'dns1.p01.nsone.net', ttl: 86400));
        break;
      case 'example.com':
        records.add(DnsRecord(type: DnsRecordType.A, value: '93.184.216.34', ttl: 86400));
        records.add(DnsRecord(type: DnsRecordType.AAAA, value: '2606:2800:220:1:248:1893:25c8:1946', ttl: 86400));
        break;
      default:
        // Simuler un échec pour les domaines non reconnus ou un succès avec des données génériques
        if (domainName.contains('.')) {
          records.add(DnsRecord(type: DnsRecordType.A, value: '192.0.2.1', ttl: 60));
          records.add(DnsRecord(type: DnsRecordType.TXT, value: 'Simulated record for $domainName', ttl: 300));
        } else {
          errorMessage = 'Nom de domaine non valide ou non trouvé (simulation).';
        }
        break;
    }

    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));

    debugPrint('DNS Lookup Result for $domainName: ${records.length} records, Error: $errorMessage');
    return DnsLookupResult(
      domainName: domainName,
      records: records,
      errorMessage: errorMessage,
    );
  }
}
