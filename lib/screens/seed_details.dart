import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeedDetailsPage extends StatelessWidget {
  final String seedName;

  const SeedDetailsPage({Key? key, required this.seedName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SeedDetails? details = seedDetailsCache[seedName];

    if (details == null) {
      return Scaffold(
        appBar: AppBar(title: Text("$seedName Details")),
        body: Center(child: Text("Details not available.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("$seedName Details")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Ideal NPK: ${details.idealNPK}"),
          Text("Growth Conditions: ${details.growthConditions}"),
          Text("Commonly Grown Areas: ${details.commonlyGrownAreas.join(', ')}"),
          Text("Soil Type: ${details.soilType}"),
          Text("Soil Conditions: ${details.soilConditions}"),
        ],
      ),
    );
  }
}

late Map<String, SeedDetails> seedDetailsCache = {};

Future<void> preloadSeedDetails() async {
  debugPrint("preloaddetails called");
  try {
    final String response = await rootBundle.loadString('assets/seed_descriptions.json');
    final List<dynamic> data = json.decode(response);

    seedDetailsCache = {
      for (var item in data)
        item['className']: SeedDetails.fromJson(item['details']),
    };

    print("Seed details loaded successfully: $seedDetailsCache");
  } catch (e) {
    print("Error loading seed details: $e");
    seedDetailsCache = {}; // Ensure seedDetailsCache is initialized as an empty map.
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















