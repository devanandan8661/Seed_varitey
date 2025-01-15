import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seed_detector/models/model.dart';
import 'package:seed_detector/controllers/esp_controller.dart';
import 'package:seed_detector/screens/seed_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ModelController mdl = Get.find<ModelController>();
    final ESPController esp = Get.find<ESPController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Seed Detector"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Detection Section
              Obx(() {
                return mdl.pickedImage.value != null
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            mdl.pickedImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'No Image Selected',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      );
              }),

              const SizedBox(height: 20),

              // Upload Image Button
              IconButton(
                onPressed: () async {
                  mdl.showImagePickerDialog();
                },
                icon: const Icon(
                  Icons.upload,
                  size: 50,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              // Display Classification Results
              Obx(() {
                return mdl.predictionResult.value != null
                    ? Column(
                        children: [
                          Text(
                            "Detected: ${mdl.predictionResult.value}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              String seedName = mdl.predictionResult.value!
                                  .split(RegExp(r'\s+\('))[0];
                                  debugPrint(seedName);
                              Get.to(() => SeedDetailsPage(seedName: seedName));
                            },
                            child: const Text("Click for More Details"),
                          ),
                        ],
                      )
                    : const SizedBox.shrink();
              }),

              const SizedBox(height: 30),

              const Divider(),

              // ESP32 Data Section
              Obx(() {
                return esp.responseMessage.isNotEmpty
                    ? Column(
                        children: [
                          const Text(
                            "ESP32 Response:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            esp.responseMessage.value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      )
                    : const Text("No data from ESP32.");
              }),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  esp.fetchResponse();
                  Get.snackbar(
                    "Fetching Data",
                    "Please wait while ESP32 data is being fetched.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text("Fetch ESP32 Response"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











