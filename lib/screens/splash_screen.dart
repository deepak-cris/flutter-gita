import 'package:flutter/material.dart' as material;
import 'package:bhagavad_gita_simplified/screens/chapter_list_screen.dart'; // Adjust path to your home screen

class SplashScreen extends material.StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends material.State<SplashScreen>
    with material.SingleTickerProviderStateMixin {
  late material.AnimationController _controller;
  late material.Animation<double> _fadeAnimation;
  late material.Animation<double> _scaleAnimation;
  late material.Animation<material.Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController with Duration from dart:core
    _controller = material.AnimationController(
      duration: const Duration(seconds: 3), // Corrected: No material. prefix
      vsync: this,
    );

    // Fade Animation for logo
    _fadeAnimation = material.Tween<double>(begin: 0.0, end: 1.0).animate(
      material.CurvedAnimation(
        parent: _controller,
        curve: material.Curves.easeIn,
      ),
    );

    // Scale Animation for pulsing effect
    _scaleAnimation = material.Tween<double>(begin: 0.8, end: 1.0).animate(
      material.CurvedAnimation(
        parent: _controller,
        curve: material.Curves.easeInOut,
      ),
    );

    // Slide Animation for text
    _slideAnimation = material.Tween<material.Offset>(
      begin: const material.Offset(0.0, 1.0),
      end: material.Offset.zero,
    ).animate(
      material.CurvedAnimation(
        parent: _controller,
        curve: material.Curves.easeOut,
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to home screen after animation
    Future.delayed(const Duration(seconds: 4), () {
      // Corrected: No material. prefix
      if (mounted) {
        material.Navigator.pushReplacement(
          context,
          material.MaterialPageRoute(builder: (context) => ChapterListScreen()),
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
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      body: material.Container(
        decoration: material.BoxDecoration(
          gradient: material.LinearGradient(
            begin: material.Alignment.topCenter,
            end: material.Alignment.bottomCenter,
            colors: [material.Colors.orange[50]!, material.Colors.white],
          ),
        ),
        child: material.Center(
          child: material.Column(
            mainAxisAlignment: material.MainAxisAlignment.center,
            children: [
              material.FadeTransition(
                opacity: _fadeAnimation,
                child: material.ScaleTransition(
                  scale: _scaleAnimation,
                  child: material.Image.asset(
                    'assets/images/app_logo.png', // Replace with your logo
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return material.Container(
                        width: 150,
                        height: 150,
                        decoration: material.BoxDecoration(
                          shape: material.BoxShape.circle,
                          color: material.Colors.orange[100],
                        ),
                        child: material.Center(
                          child: material.Text(
                            'BG',
                            style: material.TextStyle(
                              fontSize: 60,
                              fontWeight: material.FontWeight.bold,
                              color: material.Colors.orange[800],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const material.SizedBox(height: 20),
              material.SlideTransition(
                position: _slideAnimation,
                child: material.Text(
                  'Bhagavad Gita Simplified',
                  style: material.TextStyle(
                    fontSize: 28,
                    fontWeight: material.FontWeight.bold,
                    color: material.Colors.orange[900],
                    shadows: [
                      material.Shadow(
                        color: material.Colors.orange[300]!,
                        blurRadius: 10,
                        offset: const material.Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const material.SizedBox(height: 10),
              material.SlideTransition(
                position: _slideAnimation,
                child: material.Text(
                  'A Journey to Inner Peace',
                  style: material.TextStyle(
                    fontSize: 16,
                    color: material.Colors.grey[800],
                    fontStyle: material.FontStyle.italic,
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
