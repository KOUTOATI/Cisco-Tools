import 'package:flutter/material.dart'; // Keep if you use debugPrint or other Flutter specific functionalities in models.

/// Modèle pour les résultats de l'analyse IP (IPv4 et IPv6).
class IpAnalysisResult {
  final String originalIpCidr;
  final String ipVersion;
  final String ipAddress;
  final String prefixLength;
  final String ipBinary;

  // IPv4 specific
  final String? subnetMask;
  final String? subnetMaskBinary;
  final String? networkAddress;
  final String? networkAddressBinary;
  final String? broadcastAddress;
  final String? broadcastAddressBinary;
  final String? firstHost;
  final String? lastHost;
  final int? totalHosts; // Ce champ est pour IPv4, et est bien un int?

  // IPv6 specific
  final String? expandedIpv6;
  final String? compressedIpv6;
  final String? networkAddressIPv6; // Nouveau champ pour l'adresse réseau IPv6
  final String? firstUsableIPv6;    // Nouveau champ pour la première adresse utilisable IPv6
  final String? lastUsableIPv6;     // Nouveau champ pour la dernière adresse utilisable IPv6
  final String? totalAddressesIPv6; // Nouveau champ pour le nombre total d'adresses IPv6 (String pour gérer les très grands nombres)

  IpAnalysisResult({
    required this.originalIpCidr,
    required this.ipVersion,
    required this.ipAddress,
    required this.prefixLength,
    required this.ipBinary,
    this.subnetMask,
    this.subnetMaskBinary,
    this.networkAddress,
    this.networkAddressBinary,
    this.broadcastAddress,
    this.broadcastAddressBinary,
    this.firstHost,
    this.lastHost,
    this.totalHosts,
    this.expandedIpv6,
    this.compressedIpv6,
    this.networkAddressIPv6,
    this.firstUsableIPv6,
    this.lastUsableIPv6,
    this.totalAddressesIPv6,
  });
}

/// Modèle pour les résultats du générateur EUI-64.
class EUI64Result {
  final String macAddress;
  final String macBinary;
  final String interfaceId;
  final String interfaceIdBinary;
  final String processSteps;
  final String? ipv6Prefix;
  final String? fullIpv6Address;
  final String? compressedIpv6Address;

  EUI64Result({
    required this.macAddress,
    required this.macBinary,
    required this.interfaceId,
    required this.interfaceIdBinary,
    required this.processSteps,
    this.ipv6Prefix,
    this.fullIpv6Address,
    this.compressedIpv6Address,
  });
}

/// Classe pour représenter les besoins VLSM saisis par l'utilisateur.
class VLSMRequirement {
  final String name;
  final int hosts;

  VLSMRequirement({required this.name, required this.hosts});
}

/// Classe pour représenter les informations détaillées d'un sous-réseau calculé.
class CalculatedSubnetInfo {
  final String name;
  final String networkAddress; // Ex: 192.168.1.0/27
  final String firstUsableHost;
  final String lastUsableHost;
  final String broadcastAddress;
  final int availableHosts;
  final int requestedHosts; // Utile pour VLSM

  CalculatedSubnetInfo({
    required this.name,
    required this.networkAddress,
    required this.firstUsableHost,
    required this.lastUsableHost,
    required this.broadcastAddress,
    required this.availableHosts,
    required this.requestedHosts,
  });
}

/// Classe pour encapsuler les résultats du calcul de sous-réseau classique.
class ClassicSubnetResult {
  final String originalNetwork;
  final int newPrefix;
  final int bitsBorrowed;
  final int subnetsCreated;
  final int hostsPerSubnet;
  final List<CalculatedSubnetInfo> subnets;

  ClassicSubnetResult({
    required this.originalNetwork,
    required this.newPrefix,
    required this.bitsBorrowed,
    required this.subnetsCreated,
    required this.hostsPerSubnet,
    required this.subnets,
  });
}

/// Classe pour encapsuler les résultats du calcul VLSM.
class VLSMResult {
  final String originalNetwork;
  final int subnetsCreated;
  final int usedAddresses;
  final int remainingAddresses;
  final double efficiency;
  final List<CalculatedSubnetInfo> subnets;

  VLSMResult({
    required this.originalNetwork,
    required this.subnetsCreated,
    required this.usedAddresses,
    required this.remainingAddresses,
    required this.efficiency,
    required this.subnets,
  });
}

/// Type d'enregistrement DNS (A, AAAA, MX, NS, TXT, CNAME, etc.)
enum DnsRecordType { A, AAAA, MX, NS, TXT, CNAME, PTR, SRV, SOA, Unknown }

/// Modèle pour un enregistrement DNS individuel.
class DnsRecord {
  final DnsRecordType type;
  final String value;
  final int? ttl; // Time-To-Live en secondes

  DnsRecord({required this.type, required this.value, this.ttl});

  @override
  String toString() {
    return 'Type: ${type.name}, Valeur: $value' + (ttl != null ? ', TTL: $ttl s' : '');
  }
}

/// Modèle pour les résultats complets d'une recherche DNS.
class DnsLookupResult {
  final String domainName;
  final List<DnsRecord> records;
  final String? errorMessage;

  DnsLookupResult({required this.domainName, required this.records, this.errorMessage});

  bool get isSuccess => errorMessage == null;
}
