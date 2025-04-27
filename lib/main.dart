import 'package:bhagavad_gita_simplified/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhagavad Gita Simplified',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}
