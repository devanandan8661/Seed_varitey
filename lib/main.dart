import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seed_detector/models/model.dart';
import 'package:seed_detector/screens/home.dart';
import 'package:seed_detector/controllers/esp_controller.dart';
import 'package:seed_detector/screens/seed_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadSeedDetails();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Seed Detection",
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      getPages: [
        GetPage(
          name: "/home",
          page: () => const HomeScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ModelController());
            Get.lazyPut(() => ESPController());
          }),
        ),
      ],
    );
  }
}
