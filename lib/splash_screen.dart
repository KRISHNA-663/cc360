import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:niral_prj/index.dart';
import 'welcome_screen.dart';
//import 'index.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/niral_split.png", width: 200), // Change to PNG/JPG
        ],
      ),
      nextScreen:  WelcomeScreen(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 3000, // 3 seconds
      splashTransition: SplashTransition.fadeTransition, // Optional
    );
  }
}
