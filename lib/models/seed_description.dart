import 'package:flutter/services.dart';
import 'package:seed_detector/screens/seed_details.dart'; // Required for loading JSON from assets

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

// Function to load labels from a text file
Future<List<String>> loadLabels() async {
  final String rawLabels = await rootBundle.loadString('assets/labels.txt');
  // Split the file content into lines
  final List<String> lines = rawLabels.split('\n');
  
  // Remove numerical prefixes
return lines.map((line) {
  return line.trim(); // Keeping the full line as it is
}).toList();

}

