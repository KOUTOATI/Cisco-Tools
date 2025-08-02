import 'package:flutter/material.dart';
import 'package:calculator/models/ip_models.dart'; // Importe les modèles de données
import 'dart:math' as Math; // Pour Math.log et Math.pow

class IpUtils {
  // Utility Functions

  /// Converts a formatted binary string by grouping bits.
  static String formatBinary(String binary, {int groupSize = 8}) {
    if (binary.isEmpty) return '';
    final RegExp regExp = RegExp('.{1,$groupSize}');
    return binary.replaceAllMapped(regExp, (Match m) => '${m[0]} ').trim();
  }

  /// Validates an IPv4 address format.
  static bool validateIPv4(String ip) {
    debugPrint('   validateIPv4 called for: $ip');
    final parts = ip.split('.');
    if (parts.length != 4) {
      debugPrint('     Invalid IPv4: wrong number of parts (${parts.length})');
      return false;
    }

    final isValid = parts.every((part) {
      final num = int.tryParse(part);
      final result = num != null && num >= 0 && num <= 255 && part == num.toString();
      debugPrint('     Part "$part": num=$num, isValid=$result');
      return result;
    });
    debugPrint('   validateIPv4 result: $isValid');
    return isValid;
  }

  /// Validates an IPv6 address format.
  static bool validateIPv6(String ip) {
    debugPrint('   validateIPv6 called for: $ip');
    // Check for multiple '::'
    if (ip.split('::').length > 2) {
      debugPrint('     Invalid IPv6: more than one "::"');
      return false;
    }

    final parts = ip.split(':');
    // Check for valid hextet lengths and characters
    for (var part in parts) {
      if (part.isEmpty) continue; // Empty part for '::'
      if (!RegExp(r'^[0-9A-Fa-f]{1,4}$').hasMatch(part)) {
        debugPrint('     Invalid IPv6: hextet "$part" has invalid characters or length');
        return false;
      }
    }

    // Basic check for number of hextets
    if (!ip.contains('::') && parts.length != 8) {
      debugPrint('     Invalid IPv6: wrong number of hextets (without "::") - ${parts.length}');
      return false;
    }
    debugPrint('   validateIPv6 result: true');
    return true;
  }

  /// Validates a MAC address format.
  static bool validateMACAddress(String mac) {
    debugPrint('   validateMACAddress called for: $mac');
    final isValid = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$').hasMatch(mac);
    debugPrint('   validateMACAddress result: $isValid');
    return isValid;
  }

  /// Converts an IPv4 address string to its 32-bit binary string representation.
  static String ipv4ToBinary(String ip) {
    debugPrint('   ipv4ToBinary called for: $ip');
    final binary = ip.split('.').map((octet) {
      return int.parse(octet).toRadixString(2).padLeft(8, '0');
    }).join('');
    debugPrint('   ipv4ToBinary result: $binary');
    return binary;
  }

  /// Converts an IPv6 address string (expanded) to its 128-bit binary string representation.
  static String ipv6ToBinary(String ip) {
    debugPrint('   ipv6ToBinary called for: $ip');
    final binary = expandIPv6(ip).split(':').map((hextet) {
      return int.parse(hextet, radix: 16).toRadixString(2).padLeft(16, '0');
    }).join('');
    debugPrint('   ipv6ToBinary result: $binary');
    return binary;
  }

  /// Converts a 32-bit binary string to an IPv4 address string.
  static String binaryToIPv4(String binary) {
    debugPrint('   binaryToIPv4 called for: $binary');
    final cleanedBinary = binary.replaceAll(' ', '');
    debugPrint('     binaryToIPv4 - cleanedBinary: $cleanedBinary');

    if (cleanedBinary.length != 32) {
      debugPrint('     binaryToIPv4 - Invalid binary length for IPv4: ${cleanedBinary.length}');
      throw Exception('La chaîne binaire n\'a pas la bonne longueur pour une adresse IPv4 (doit être 32 bits).');
    }

    List<String> octets = [];
    for (int i = 0; i < 4; i++) {
      octets.add(cleanedBinary.substring(i * 8, (i + 1) * 8));
    }
    debugPrint('     binaryToIPv4 - extracted octets: $octets');

    final ipv4 = octets.map((octet) => int.parse(octet, radix: 2)).join('.');
    debugPrint('   binaryToIPv4 result: $ipv4');
    return ipv4;
  }

  /// Converts a 128-bit binary string to an IPv6 address string (expanded).
  static String binaryToIPv6(String binary) {
    debugPrint('   binaryToIPv6 called for: $binary');
    final cleanedBinary = binary.replaceAll(' ', '');
    final hextets = <String>[];
    for (int i = 0; i < cleanedBinary.length; i += 16) {
      hextets.add(cleanedBinary.substring(i, (i + 16).clamp(0, cleanedBinary.length)));
    }
    debugPrint('     binaryToIPv6 - extracted hextets: $hextets');

    final ipv6 = hextets.map((hextet) {
      if (hextet.isEmpty) return '0'; // Should not happen with padLeft, but for safety
      return int.parse(hextet, radix: 2).toRadixString(16).padLeft(4, '0');
    }).join(':');
    debugPrint('   binaryToIPv6 result: $ipv6');
    return ipv6;
  }

  /// Converts a MAC address to its binary representation.
  static String macToBinary(String macAddress) {
    debugPrint('   macToBinary called for: $macAddress');
    final binary = macAddress
        .replaceAll(RegExp(r'[:-]'), '')
        .split(RegExp(r'.{2}'))
        .where((e) => e.isNotEmpty)
        .map((hex) => int.parse(hex, radix: 16).toRadixString(2).padLeft(8, '0'))
        .join(' ');
    debugPrint('   macToBinary result: $binary');
    return binary;
  }

  /// Converts an EUI-64 Interface ID to its binary representation.
  static String interfaceIDToBinary(String interfaceID) {
    debugPrint('   interfaceIDToBinary called for: $interfaceID');
    final binary = interfaceID
        .replaceAll(':', '')
        .split(RegExp(r'.{4}'))
        .where((e) => e.isNotEmpty)
        .map((hex) => int.parse(hex, radix: 16).toRadixString(2).padLeft(16, '0'))
        .join(' ');
    debugPrint('   interfaceIDToBinary result: $binary');
    return binary;
  }

  /// Expands a compressed IPv6 address (with '::') to its full 8-hextet form.
  static String expandIPv6(String ipv6) {
    debugPrint('   expandIPv6 called for: $ipv6');
    if (ipv6.contains('::')) {
      final parts = ipv6.split('::');
      final leftParts = parts[0].isNotEmpty ? parts[0].split(':') : [];
      final rightParts = parts.length > 1 && parts[1].isNotEmpty ? parts[1].split(':') : [];

      final missingParts = 8 - leftParts.length - rightParts.length;
      final middleParts = List.filled(missingParts, '0000');

      final allParts = [...leftParts, ...middleParts, ...rightParts];
      final expanded = allParts.map((part) => part.padLeft(4, '0')).join(':');
      debugPrint('   expandIPv6 result (with ::): $expanded');
      return expanded;
    }
    final expanded = ipv6.split(':').map((part) => part.padLeft(4, '0')).join(':');
    debugPrint('   expandIPv6 result (no ::): $expanded');
    return expanded;
  }

  /// Compresses an IPv6 address by replacing the longest sequence of zero hextets with '::'.
  static String compressIPv6(String ipv6) {
    debugPrint('   compressIPv6 called for: $ipv6');
    final parts = expandIPv6(ipv6).split(':');

    int maxZeroStart = -1;
    int maxZeroLength = 0;
    int currentZeroStart = -1;
    int currentZeroLength = 0;

    for (int i = 0; i < parts.length; i++) {
      if (int.tryParse(parts[i], radix: 16) == 0) {
        if (currentZeroStart == -1) {
          currentZeroStart = i;
          currentZeroLength = 1;
        } else {
          currentZeroLength++;
        }
      } else {
        if (currentZeroLength > maxZeroLength) {
          maxZeroStart = currentZeroStart;
          maxZeroLength = currentZeroLength;
        }
        currentZeroStart = -1;
        currentZeroLength = 0;
      }
    }

    if (currentZeroLength > maxZeroLength) {
      maxZeroStart = currentZeroStart;
      maxZeroLength = currentZeroLength;
    }

    String compressed;
    if (maxZeroLength >= 2) { // Only compress if at least two zero hextets
      final beforeZeros = parts.sublist(0, maxZeroStart);
      final afterZeros = parts.sublist(maxZeroStart + maxZeroLength);

      final cleanBefore = beforeZeros.map((part) => int.parse(part, radix: 16).toRadixString(16)).map((e) => e == '0' ? '0' : e).toList();
      final cleanAfter = afterZeros.map((part) => int.parse(part, radix: 16).toRadixString(16)).map((e) => e == '0' ? '0' : e).toList();

      if (maxZeroStart == 0 && (maxZeroStart + maxZeroLength == parts.length)) {
          compressed = '::'; // Case where the entire address is zeros
      } else if (maxZeroStart == 0) {
        compressed = '::${cleanAfter.join(':')}';
      } else if (maxZeroStart + maxZeroLength == parts.length) {
        compressed = '${cleanBefore.join(':')}::';
      } else {
        compressed = '${cleanBefore.join(':')}::${cleanAfter.join(':')}';
      }
    } else {
      compressed = parts.map((part) => int.parse(part, radix: 16).toRadixString(16)).map((e) => e == '0' ? '0' : e).join(':');
    }
    debugPrint('   compressIPv6 result: $compressed');
    return compressed;
  }

  /// Converts an IPv6 address string (can be compressed) to a BigInt.
  static BigInt _ipv6StringToBigInt(String ipv6String) {
    final expanded = expandIPv6(ipv6String);
    final hextets = expanded.split(':');
    BigInt ipv6BigInt = BigInt.zero;
    for (int i = 0; i < hextets.length; i++) {
      ipv6BigInt = (ipv6BigInt << 16) | BigInt.parse(hextets[i], radix: 16);
    }
    return ipv6BigInt;
  }

  /// Converts a BigInt to a compressed IPv6 address string.
  static String _bigIntToIPv6String(BigInt ipv6BigInt) {
    List<String> parts = [];
    for (int i = 0; i < 8; i++) {
      // Extract 16 bits at a time (a hextet)
      final hextet = (ipv6BigInt >> (112 - i * 16)).toInt() & 0xFFFF; // Correction ici: .toInt() avant & 0xFFFF
      parts.add(hextet.toRadixString(16).padLeft(4, '0'));
    }
    // Compress the IPv6 address
    return compressIPv6(parts.join(':'));
  }

  // EUI-64 Interface ID Generator functionality
  static EUI64Result generateEUI64(String macAddress, {String? ipv6Prefix}) {
    debugPrint('   generateEUI64 called for MAC: $macAddress, Prefix: $ipv6Prefix');
    final cleanedMac = macAddress.replaceAll(RegExp(r'[:-]'), '').toUpperCase();

    if (cleanedMac.length != 12) {
      throw Exception('L\'adresse MAC doit contenir 12 caractères hexadécimaux.');
    }

    final firstPart = cleanedMac.substring(0, 6);
    final secondPart = cleanedMac.substring(6, 12);

    final eui64 = '${firstPart}FFFE$secondPart';
    debugPrint('     EUI-64 before bit flip: $eui64');

    final firstByte = int.parse(eui64.substring(0, 2), radix: 16);
    final modifiedFirstByte = (firstByte ^ 0x02).toRadixString(16).padLeft(2, '0').toUpperCase();
    debugPrint('     Original first byte: ${eui64.substring(0, 2)} (hex) -> ${firstByte.toRadixString(2).padLeft(8, '0')} (binary)');
    debugPrint('     Modified first byte: $modifiedFirstByte (hex) -> ${(firstByte ^ 0x02).toRadixString(2).padLeft(8, '0')} (binary)');


    final modifiedEUI64 = '$modifiedFirstByte${eui64.substring(2)}';
    debugPrint('     EUI-64 after bit flip: $modifiedEUI64');

    final interfaceID = modifiedEUI64.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match[0]}:').substring(0, modifiedEUI64.length + 3).toLowerCase();
    debugPrint('   Generated Interface ID: $interfaceID');

    final List<String> processSteps = [
      'Étape 1 - MAC originale: ${macAddress.toUpperCase()}',
      'Étape 2 - Insertion FFFE: ${firstPart.replaceAllMapped(RegExp(r'.{2}'), (m) => '${m[0]}:').substring(0, firstPart.length + 2)}${secondPart.replaceAllMapped(RegExp(r'.{2}'), (m) => '${m[0]}:').substring(0, secondPart.length + 2)} (format MAC)',
      'Étape 2 - Insertion FFFE (continu): ${firstPart}FFFE${secondPart} (format concaténé)',
      'Étape 3 - Inversion bit U/L (7ème bit du premier octet): ${modifiedFirstByte}${cleanedMac.substring(2, 6)}FFFE${secondPart}',
      'Étape 4 - Format final: ${interfaceID}',
    ];

    String? fullIpv6Address;
    String? compressedIpv6Address;

    if (ipv6Prefix != null && ipv6Prefix.isNotEmpty) {
      debugPrint('   Generating full IPv6 address with prefix');
      final parts = ipv6Prefix.split('/');
      if (parts.length != 2) {
        throw Exception('Format de préfixe invalide (ex: 2001:db8::/64)');
      }
      final prefixPart = parts[0];
      final prefixLength = int.tryParse(parts[1]);

      if (prefixLength == null || prefixLength < 0 || prefixLength > 128) {
        throw Exception('Longueur de préfixe invalide (0-128)');
      }

      fullIpv6Address = IpUtils.generateCompleteAddress(prefixPart, interfaceID);
      compressedIpv6Address = IpUtils.compressIPv6(fullIpv6Address);
      debugPrint('   Full IPv6 Address: $fullIpv6Address');
      debugPrint('   Compressed IPv6 Address: $compressedIpv6Address');
    }

    return EUI64Result(
      macAddress: macAddress.toUpperCase(),
      macBinary: macToBinary(macAddress),
      interfaceId: interfaceID,
      interfaceIdBinary: interfaceIDToBinary(interfaceID),
      processSteps: processSteps.join('\n'),
      fullIpv6Address: fullIpv6Address,
      compressedIpv6Address: compressedIpv6Address,
      ipv6Prefix: ipv6Prefix,
    );
  }

  /// Generates a complete IPv6 address by combining a prefix and an interface ID.
  static String generateCompleteAddress(String prefix, String interfaceID) {
    debugPrint('   generateCompleteAddress called for prefix: $prefix, interfaceID: $interfaceID');
    final expandedPrefix = expandIPv6(prefix);
    // Take the first 4 hextets (64 bits) of the prefix for a /64 common case
    // This assumes the prefix is always /64 or shorter for EUI-64 combination
    final prefixParts = expandedPrefix.split(':').take(4).toList();
    final interfaceIDParts = interfaceID.split(':');
    final fullAddress = [...prefixParts, ...interfaceIDParts].join(':');
    debugPrint('   generateCompleteAddress result: $fullAddress');
    return fullAddress;
  }


  // IP Analyzer (replaces old convertIp)
  static IpAnalysisResult analyzeIp(String ipCidr, String ipVersion) {
    debugPrint('IpUtils.analyzeIp called with: $ipCidr, version: $ipVersion');

    if (!ipCidr.contains('/')) {
      throw Exception('Format CIDR invalide. Utilisez "adresse/longueur_préfixe".');
    }

    final parts = ipCidr.split('/');
    final ipAddress = parts[0].trim();
    final prefixLengthStr = parts[1].trim();
    final int prefixLength = int.tryParse(prefixLengthStr) ?? -1;

    if (ipVersion == 'IPv4') {
      if (prefixLength == -1 || prefixLength < 0 || prefixLength > 32) {
        throw Exception('Longueur de préfixe invalide (0-32).');
      }
      if (!validateIPv4(ipAddress)) {
        throw Exception('Adresse IPv4 invalide.');
      }
      debugPrint('   Analyzing IPv4: $ipAddress/$prefixLength');

      final ipBinary = ipv4ToBinary(ipAddress);
      final subnetMaskBinary = ''.padLeft(prefixLength, '1').padRight(32, '0');
      final subnetMask = binaryToIPv4(subnetMaskBinary);

      final networkAddressBinary = (int.parse(ipBinary, radix: 2) & int.parse(subnetMaskBinary, radix: 2))
          .toRadixString(2)
          .padLeft(32, '0');
      final networkAddress = binaryToIPv4(networkAddressBinary);

      final broadcastAddressBinary = (int.parse(networkAddressBinary, radix: 2) | (~int.parse(subnetMaskBinary, radix: 2) & 0xFFFFFFFF))
          .toRadixString(2)
          .padLeft(32, '0');
      final broadcastAddress = binaryToIPv4(broadcastAddressBinary);

      final int totalHosts = (1 << (32 - prefixLength)) - 2; // -2 for network and broadcast
      final firstHost = (totalHosts > 0) ? binaryToIPv4((int.parse(networkAddressBinary, radix: 2) + 1).toRadixString(2).padLeft(32, '0')) : 'N/A';
      final lastHost = (totalHosts > 0) ? binaryToIPv4((int.parse(broadcastAddressBinary, radix: 2) - 1).toRadixString(2).padLeft(32, '0')) : 'N/A';


      return IpAnalysisResult(
        originalIpCidr: ipCidr,
        ipVersion: ipVersion,
        ipAddress: ipAddress,
        prefixLength: prefixLengthStr,
        ipBinary: formatBinary(ipBinary, groupSize: 8),
        subnetMask: subnetMask,
        subnetMaskBinary: formatBinary(subnetMaskBinary, groupSize: 8),
        networkAddress: networkAddress,
        networkAddressBinary: formatBinary(networkAddressBinary, groupSize: 8),
        broadcastAddress: broadcastAddress,
        broadcastAddressBinary: formatBinary(broadcastAddressBinary, groupSize: 8),
        firstHost: firstHost,
        lastHost: lastHost,
        totalHosts: totalHosts > 0 ? totalHosts : 0, // Ensure non-negative
      );
    } else if (ipVersion == 'IPv6') {
      if (prefixLength == -1 || prefixLength < 0 || prefixLength > 128) {
        throw Exception('Longueur de préfixe invalide (0-128).');
      }
      if (!validateIPv6(ipAddress)) {
        throw Exception('Adresse IPv6 invalide.');
      }
      debugPrint('   Analyzing IPv6: $ipAddress/$prefixLength');

      final ipBigInt = _ipv6StringToBigInt(ipAddress);

      // Calculate the network mask (1s for network part, 0s for host part)
      // Example: for /64, mask has 64 ones, then 64 zeros.
      // We create a mask of zeros at the right, then invert it.
      final BigInt hostBitsMask = (BigInt.one << (128 - prefixLength)) - BigInt.one;
      final BigInt networkMask = ~hostBitsMask; // Invert to get 1s for network part

      // Network Address: IP address ANDed with the network mask
      final BigInt networkAddressBigInt = ipBigInt & networkMask;
      final String networkAddress = _bigIntToIPv6String(networkAddressBigInt);

      // First Usable Address: In IPv6, the network address itself is generally usable.
      // We'll use the network address as the "first usable" for simplicity and common practice.
      final String firstUsable = networkAddress;

      // Last Usable Address: Network address ORed with the host bits mask (all host bits set to 1)
      final BigInt lastUsableBigInt = networkAddressBigInt | hostBitsMask;
      final String lastUsable = _bigIntToIPv6String(lastUsableBigInt);

      // Total Hosts: 2^(128 - prefixLength)
      // Note: No -2 for network/broadcast as in IPv4. All addresses are generally usable.
      final BigInt totalAddressesBigInt = BigInt.one << (128 - prefixLength);
      // Convert to a string, as it can be a very large number
      final String totalAddresses = totalAddressesBigInt.toString();


      return IpAnalysisResult(
        originalIpCidr: ipCidr,
        ipVersion: ipVersion,
        ipAddress: ipAddress,
        prefixLength: prefixLengthStr,
        ipBinary: formatBinary(ipv6ToBinary(ipAddress), groupSize: 16),
        expandedIpv6: expandIPv6(ipAddress),
        compressedIpv6: compressIPv6(ipAddress),
        // New IPv6 specific fields
        networkAddressIPv6: networkAddress,
        firstUsableIPv6: firstUsable,
        lastUsableIPv6: lastUsable,
        totalAddressesIPv6: totalAddresses,
      );
    } else {
      throw Exception('Version IP non supportée.');
    }
  }

  /// Calcule les informations d'un sous-réseau classique.
  /// Prend en entrée l'adresse réseau au format CIDR (ex: "192.168.1.0/24")
  /// et le nombre de sous-réseaux souhaités.
  /// Retourne un objet `ClassicSubnetResult` contenant le résumé et la liste des sous-réseaux.
  static ClassicSubnetResult calculateClassicSubnet(
      String networkAddress, int subnetCount) {
    final parts = networkAddress.split('/');
    if (parts.length != 2) {
      throw Exception('Format d\'adresse réseau invalide (doit être IP/CIDR)');
    }

    final network = parts[0];
    final prefix = parts[1];

    // Valider les entrées
    if (!validateIPv4(network)) {
      throw Exception('Format d\'adresse réseau invalide');
    }

    final prefixNum = int.tryParse(prefix);
    if (prefixNum == null || prefixNum < 0 || prefixNum > 30) {
      throw Exception('Préfixe invalide (doit être entre 0 et 30)');
    }

    if (subnetCount < 2) {
      throw Exception('Nombre de sous-réseaux invalide (minimum 2)');
    }

    // Calculer les bits nécessaires pour les sous-réseaux
    final bitsNeeded = (subnetCount > 0) ? (Math.log(subnetCount) / Math.log(2)).ceil() : 0;
    final newPrefix = prefixNum + bitsNeeded;

    if (newPrefix > 30) { // Max /30 for IPv4 usable hosts
      throw Exception('Pas assez de bits disponibles pour créer ces sous-réseaux');
    }

    // Calculer la taille du sous-réseau et le nombre d'hôtes
    final hostsPerSubnet = (Math.pow(2, 32 - newPrefix) - 2).toInt();
    final subnetSize = (Math.pow(2, 32 - newPrefix)).toInt();

    // Générer les sous-réseaux
    final networkBinary = ipv4ToBinary(network);
    final networkInt = int.parse(networkBinary, radix: 2);

    List<CalculatedSubnetInfo> subnets = [];

    for (int i = 0; i < subnetCount; i++) {
      final subnetNetworkInt = networkInt + (i * subnetSize);
      final subnetNetworkBinary = subnetNetworkInt.toRadixString(2).padLeft(32, '0');
      final subnetNetwork = binaryToIPv4(subnetNetworkBinary);

      final broadcastInt = subnetNetworkInt + subnetSize - 1;
      final broadcastBinary = broadcastInt.toRadixString(2).padLeft(32, '0');
      final broadcast = binaryToIPv4(broadcastBinary);

      final firstUsableInt = subnetNetworkInt + 1;
      final firstUsableBinary = firstUsableInt.toRadixString(2).padLeft(32, '0');
      final firstUsable = binaryToIPv4(firstUsableBinary);

      final lastUsableInt = broadcastInt - 1;
      final lastUsableBinary = lastUsableInt.toRadixString(2).padLeft(32, '0');
      final lastUsable = binaryToIPv4(lastUsableBinary);

      subnets.add(CalculatedSubnetInfo(
        name: 'Sous-réseau ${i + 1}', // Nom générique pour le classique
        networkAddress: '$subnetNetwork/$newPrefix',
        firstUsableHost: firstUsable,
        lastUsableHost: lastUsable,
        broadcastAddress: broadcast,
        availableHosts: hostsPerSubnet,
        requestedHosts: hostsPerSubnet, // Pour la cohérence avec VLSM
      ));
    }

    return ClassicSubnetResult(
      originalNetwork: networkAddress,
      newPrefix: newPrefix,
      bitsBorrowed: bitsNeeded,
      subnetsCreated: subnetCount,
      hostsPerSubnet: hostsPerSubnet,
      subnets: subnets,
    );
  }

  /// Calcule les informations des sous-réseaux VLSM.
  /// Prend en entrée l'adresse réseau au format CIDR (ex: "192.168.1.0/24")
  /// et une liste de `VLSMRequirement` (nom du réseau, nombre d'hôtes requis).
  /// Retourne un objet `VLSMResult` contenant le résumé et la liste des sous-réseaux calculés.
  static VLSMResult calculateVLSM(
      String networkAddress, List<VLSMRequirement> requirements) {
    final parts = networkAddress.split('/');
    if (parts.length != 2) {
      throw Exception('Format d\'adresse réseau invalide (doit être IP/CIDR)');
    }

    final network = parts[0];
    final prefix = parts[1];

    // Valider l'adresse réseau
    if (!validateIPv4(network)) {
      throw Exception('Format d\'adresse réseau invalide');
    }

    final prefixNum = int.tryParse(prefix);
    if (prefixNum == null || prefixNum < 0 || prefixNum > 30) {
      throw Exception('Préfixe invalide (doit être entre 0 et 30)');
    }

    if (requirements.isEmpty) {
      throw Exception('Veuillez ajouter au moins un besoin de sous-réseau');
    }

    // Trier les besoins par nombre d'hôtes (décroissant)
    requirements.sort((a, b) => b.hosts.compareTo(a.hosts));

    final networkBinary = ipv4ToBinary(network);
    final networkInt = int.parse(networkBinary, radix: 2);
    int currentAddress = networkInt;

    List<CalculatedSubnetInfo> subnets = [];
    int totalUsedAddresses = 0;

    for (var req in requirements) {
      // Calculer la taille de sous-réseau requise (puissance de 2)
      // +2 pour l'adresse réseau et l'adresse de diffusion
      final requiredSize = (Math.pow(2, (Math.log(req.hosts + 2) / Math.log(2)).ceil())).toInt();
      final subnetBits = 32 - (Math.log(requiredSize) / Math.log(2)).toInt();

      if (subnetBits < prefixNum) {
        throw Exception(
            'Pas assez d\'espace pour le réseau "${req.name}" (${req.hosts} hôtes)');
      }

      // Calculer les adresses
      final subnetNetworkBinary = currentAddress.toRadixString(2).padLeft(32, '0');
      final subnetNetwork = binaryToIPv4(subnetNetworkBinary);

      final broadcastInt = currentAddress + requiredSize - 1;
      final broadcastBinary = broadcastInt.toRadixString(2).padLeft(32, '0');
      final broadcast = binaryToIPv4(broadcastBinary);

      final firstUsable = binaryToIPv4((currentAddress + 1).toRadixString(2).padLeft(32, '0'));
      final lastUsable = binaryToIPv4((broadcastInt - 1).toRadixString(2).padLeft(32, '0'));

      final actualHosts = requiredSize - 2;

      subnets.add(CalculatedSubnetInfo(
        name: req.name,
        networkAddress: '$subnetNetwork/$subnetBits',
        firstUsableHost: firstUsable,
        lastUsableHost: lastUsable,
        broadcastAddress: broadcast,
        availableHosts: actualHosts,
        requestedHosts: req.hosts,
      ));

      currentAddress += requiredSize;
      totalUsedAddresses += requiredSize;
    }

    final totalAvailable = (Math.pow(2, 32 - prefixNum)).toInt();
    final remainingAddresses = totalAvailable - totalUsedAddresses;
    final efficiency = (totalUsedAddresses / totalAvailable) * 100;

    return VLSMResult(
      originalNetwork: networkAddress,
      subnetsCreated: requirements.length,
      usedAddresses: totalUsedAddresses,
      remainingAddresses: remainingAddresses,
      efficiency: efficiency,
      subnets: subnets,
    );
  }
}
