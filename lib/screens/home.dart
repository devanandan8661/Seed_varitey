import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seed_detector/models/model.dart';
import 'package:seed_detector/controllers/esp_controller.dart';
import 'package:seed_detector/screens/seed_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModelController modelController = Get.find<ModelController>();
    final ESPController espController = Get.find<ESPController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Seed Detector"),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Detection Section
              Obx(() {
                return modelController.pickedImage.value != null
                    ? Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  modelController.pickedImage.value!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Selected Image',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                'No Image Selected',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
              }),

              const SizedBox(height: 20),

              // Upload Image Button
              ElevatedButton(
                onPressed: () => modelController.showImagePickerDialog(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                foregroundColor: Colors.white),
                child: const Text("Upload Image"),
              ),

              const SizedBox(height: 20),

              // Display Classification Results
              Obx(() {
                return modelController.predictionResult.value != null
                    ? Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Detected: ${modelController.predictionResult.value}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  String seedName = modelController.predictionResult.value!;
                                  Get.to(() => SeedDetailsPage(seedName: seedName));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                                foregroundColor: Colors.white),
                                child: const Text("Click for More Details"),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),

              const SizedBox(height: 30),
              const Divider(),

              // ESP32 Data Section
              Obx(() {
                return espController.responseMessage.isNotEmpty
                    ? Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                "ESP32 Response:",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(
                                espController.responseMessage.value,
                                style: const TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Text("No data from ESP32.");
              }),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  espController.fetchResponse();
                  Get.snackbar(
                    "Fetching Data",
                    "Please wait while ESP32 data is being fetched.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                foregroundColor: Colors.white),
                child: const Text("Fetch ESP32 Response"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









