import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_gemini/widgets/background.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int correct;
  final int wrong;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.correct,
    required this.wrong,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

         QuizOproBackground(child: Container()),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  /// 🎉 Title
                  const Text(
                    "Quiz Completed!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🏆 Trophy
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.yellow, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.6),
                          blurRadius: 30,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// 🎊 Text
                  const Text(
                    "Congratulations!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Your result:",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  /// 📊 Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCard("SCORE", "$score\n   Points.", Colors.cyan ),
                      _buildCard("CORRECT", "$correct\nOut of $total", Colors.green),
                      _buildCard("WRONG", "$wrong\nOut of $total", Colors.red),
                      // _buildCard("SKIPPED", "$wrong\nOut of $total", Colors.red),
                    ],
                  ),

                  const Spacer(),

                  /// 🔘 Buttons
                  Row(
                    children: [

                      /// HOME
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Get.offAllNamed("/home");
                          },
                          child: const Text(
                            "HOME",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      /// PLAY AGAIN
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Get.back(); // ya new quiz start
                          },
                          child: const Text(
                            "PLAY AGAIN",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Widget
  Widget _buildCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}