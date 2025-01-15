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
      theme: GreenWhiteTheme.greenWhite, 
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

class GreenWhiteTheme {
  static final ThemeData greenWhite = ThemeData(
    primaryColor: Colors.green,             // Background color
    scaffoldBackgroundColor: Colors.white,     // Scaffold background
    textTheme: TextTheme(
      bodyLarge: TextStyle(                     // Body text style
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,                   // Black text on white background
      ),
      headlineLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.green,                      // Green for AppBar
      iconTheme: IconThemeData(color: Colors.white),  // White icons
    ),
    iconTheme: IconThemeData(color: Colors.green),  // Icons in green
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.green,               // Green button background
      textTheme: ButtonTextTheme.primary,     // Text color is white
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white).copyWith(background: Colors.white),
  );
}

