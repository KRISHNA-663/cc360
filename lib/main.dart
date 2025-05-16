import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:niral_prj/index.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}
