import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../utils.dart';

class ModelController extends GetxController {
  Rx<File?> pickedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  Rx<String?> predictionResult = Rx<String?>(null);
  late Interpreter _interpreter;
  List<String> seedLabels = [];

  @override
  void onInit() {
    super.onInit();
    loadSeedLabels();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
    } catch (e) {
      print('Error loading model: $e');
      Get.snackbar('Error', 'Failed to load ML model');
    }
  }

  Future<void> loadSeedLabels() async {
    seedLabels = await loadLabels();
    if (seedLabels.isEmpty) {
      Get.snackbar('Error', 'Labels file is empty or misaligned.');
    } else {
      print('Loaded labels: $seedLabels');
    }
  }

  Future<void> classifyImage() async {
    if (pickedImage.value == null) {
      Get.snackbar('Error', 'Please pick an image first');
      return;
    }

    try {
      img.Image? imageInput =
          img.decodeImage(pickedImage.value!.readAsBytesSync());
      img.Image resizedImage =
          img.copyResize(imageInput!, width: 224, height: 224);

      var inputImage = List.generate(
          1,
          (i) => List.generate(
              224,
              (j) => List.generate(
                  224,
                  (k) => [
                        resizedImage.getPixel(k, j).r / 255.0 - 0.5,
                        resizedImage.getPixel(k, j).g / 255.0 - 0.5,
                        resizedImage.getPixel(k, j).b / 255.0 - 0.5,
                      ])));

      var outputBuffer =
          List.filled(1 * seedLabels.length, 0.0).reshape([1, seedLabels.length]);

      _interpreter.run(inputImage, outputBuffer);

      double maxProb = -1;
      int maxIndex = -1;

      for (int i = 0; i < seedLabels.length; i++) {
        if (outputBuffer[0][i] > maxProb) {
          maxProb = outputBuffer[0][i];
          maxIndex = i;
        }
      }

      predictionResult.value = maxIndex != -1
          ? '${seedLabels[maxIndex]} (Confidence: ${(maxProb * 100).toStringAsFixed(2)}%)'
          : 'Unable to classify';

      print('Prediction result: ${predictionResult.value}');
    } catch (e) {
      print('Classification error: $e');
      Get.snackbar('Error', 'Failed to classify image');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
        classifyImage();
      } else {
        Get.snackbar(
          'Image Selection',
          'No image was selected',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}







