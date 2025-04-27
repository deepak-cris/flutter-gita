import 'package:bhagavad_gita_simplified/screens/home_screen.dart';
import 'package:flutter/material.dart'; // Adjust path to your home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController with Duration from dart:core
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Corrected: No  prefix
      vsync: this,
    );

    // Fade Animation for logo
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Scale Animation for pulsing effect
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Slide Animation for text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation
    _controller.forward();

    // Navigate to home screen after animation
    Future.delayed(const Duration(seconds: 4), () {
      // Corrected: No  prefix
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/app_logo.png', // Replace with your logo
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange[100],
                        ),
                        child: Center(
                          child: Text(
                            'BG',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Bhagavad Gita Simplified',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                    shadows: [
                      Shadow(
                        color: Colors.orange[300]!,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'A Journey to Inner Peace',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
