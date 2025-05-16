import 'dart:ui';
import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';
import 'theme.dart';
import 'welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/farmer.jpg', // 🔥 Replace with your image path
            fit: BoxFit.cover,
          ),
          
          // Blurring the background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust blur strength
            child: Container(
              color: Colors.black.withOpacity(0.2), // Slight overlay for better readability
            ),
          ),

          // Main content
          Column(
            children: [
              const SizedBox(height: 100),
              Flexible(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome!\n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: '\nOne stop for farmers future 🌾',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Sign in',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInScreen()),
                            );
                          },
                          color: Colors.transparent,
                          textColor: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Sign up',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          color: const Color.fromARGB(255, 255, 255, 255),
                          textColor: lightColorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
