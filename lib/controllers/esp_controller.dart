import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ESPController extends GetxController {
  RxString responseMessage = ''.obs;
  final String espUrl = "http://192.168.212.198";

  Future<void> fetchResponse() async {
    try {
      final response = await http.get(Uri.parse(espUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        responseMessage.value = data['message'] ?? "No message received.";
      } else {
        responseMessage.value =
            "Failed to fetch data. Status code: ${response.statusCode}";
      }
    } catch (e) {
      responseMessage.value = "Error fetching ESP32 data: $e";
    }
  }
}


