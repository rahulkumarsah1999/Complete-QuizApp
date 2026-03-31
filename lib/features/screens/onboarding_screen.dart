import 'package:flutter/material.dart';
import 'package:quiz_app_with_gemini/features/screens/loginpage.dart';
import 'package:quiz_app_with_gemini/widgets/animated_button.dart';
import '../../widgets/background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List onBoardingData = [
    {
      "image": 'assets/images/onboardingscreen.png',
      "title": 'EMBARK ON A JOURNEY',
      "description":
          'Discover tons of quiz topics and find your perfect challenge',
    },
    {
      "image": 'assets/images/screen2.png',
      "title": 'POWERED BY GEMINI AI',
      "description":
          'Explore dynamic, category-based questions tailored to your skill level, generated instantly',
    },
    {
      "image": 'assets/images/screen3.png',
      "title": 'COMPETE & CONQUER',
      "description":
          'Select your favorite category and difficulty. Start your personalized quiz challenge and climb the leaderboard',
    },
  ];

  void _onNextPressed() {
    if (_currentPage < onBoardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Home or Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == onBoardingData.length - 1;
    return QuizOproBackground(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onBoardingData.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Illustration
                      Image.asset(
                        onBoardingData[index]['image'],
                        height: 400, // Adjust based on your image size
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 6),
                      // Dynamic Title with numbering (e.g., 1. TITLE)
                      Text(
                        onBoardingData[index]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BlackItalic',
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Description
                      Text(
                        onBoardingData[index]['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Bricolage',
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. Footer (Dots + Buttons)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                // Pagination Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onBoardingData.length,
                    (index) => _buildDot(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 30),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: AnimatedButton(
                    onTap: _onNextPressed,

                    text: isLastPage ? "LET'S START" : "NEXT",
                    gradientColors: [Colors.lightBlueAccent, Colors.blueAccent],
                  ),
                ),

                // Skip Button
                _currentPage == 0
                    ? TextButton(
                        onPressed: () {
                          // Navigate to Home or Login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "SKIP",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white24,
        shape: BoxShape.circle,
      ),
    );
  }
}
