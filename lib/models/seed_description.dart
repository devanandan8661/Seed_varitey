import 'dart:convert';
import 'package:flutter/services.dart'; // Required for loading JSON from assets

class SeedDescription {
  final String className;
  final SeedDetails details;

  SeedDescription({required this.className, required this.details});

  // Factory method to create an object from JSON
  factory SeedDescription.fromJson(Map<String, dynamic> json) {
    return SeedDescription(
      className: json['className'],
      details: SeedDetails.fromJson(json['details']),
    );
  }
}

class SeedDetails {
  final String idealNPK;
  final String growthConditions;
  final List<String> commonlyGrownAreas;
  final String soilType;
  final String soilConditions;

  SeedDetails({
    required this.idealNPK,
    required this.growthConditions,
    required this.commonlyGrownAreas,
    required this.soilType,
    required this.soilConditions,
  });

  // Factory method to create an object from JSON
  factory SeedDetails.fromJson(Map<String, dynamic> json) {
    return SeedDetails(
      idealNPK: json['idealNPK'],
      growthConditions: json['growthConditions'],
      commonlyGrownAreas: List<String>.from(json['commonlyGrownAreas']),
      soilType: json['soilType'],
      soilConditions: json['soilConditions'],
    );
  }
}

// Function to load the JSON file from assets and parse it
Future<List<SeedDescription>> loadSeedDescriptions() async {
  // Load the JSON file from assets
  final String response = await rootBundle.loadString('assets/seed_descriptions.json');

  // Parse the JSON data into a list of maps
  final List<dynamic> data = jsonDecode(response);

  // Map the JSON data to a list of SeedDescription objects
  return data.map((json) => SeedDescription.fromJson(json)).toList();
}

