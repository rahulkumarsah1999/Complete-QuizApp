import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/background.dart';
import '../models/quiz_attempt_model.dart';

class QuizDetailScreen extends StatelessWidget {
  final QuizAttempt attempt;

  const QuizDetailScreen({super.key, required this.attempt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: QuizOproBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                  title: Text("${attempt.category} Quiz Details",
                    style: TextStyle(color: Colors.white),
                  ),
                leading: IconButton(
                    onPressed: ()=> Get.back(),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: attempt.questions.length,
                  itemBuilder: (context, index) {
                    final q = attempt.questions[index];
                    final userChoice = attempt.selectedAnswers[index];
                    return _buildReviewCard(q, userChoice);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(dynamic question, int? userChoice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...List.generate(question.options.length, (i) {
            bool isCorrect = i == question.correctAnswer;
            bool isUserChoice = i == userChoice;
            Color color = isCorrect ? Colors.green : (isUserChoice ? Colors.red : Colors.white24);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.2), border: Border.all(color: color)),
              child: Text(question.options[i], style: const TextStyle(color: Colors.white)),
            );
          })
        ],
      ),
    );
  }
}