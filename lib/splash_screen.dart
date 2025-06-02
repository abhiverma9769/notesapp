
import 'package:JaiShreeRam/screen/home_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: SizedBox(
          height: 3500, // Adjust height if needed
          child: Lottie.asset(
            'assets/animation/abhi.json',
          ),
        ),
      ),
      nextScreen: const HomeScreen(),
      duration: 3500,
      backgroundColor: Colors.white,
      splashIconSize: 350, // Optional: controls splash size
    );
  }
}
