import 'package:flutter/services.dart';

Future<List<String>> loadLabels() async {
  try {
    final data = await rootBundle.loadString('assets/labels.txt');
    return data
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty) // Ensure no empty lines are included
        .toList();
  } catch (e) {
    print('Error loading labels: $e');
    return [];
  }
}

