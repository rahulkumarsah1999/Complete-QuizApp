import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quizcontroller.dart';
import 'result_screen.dart';
import '../../widgets/background.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  const QuizScreen({
    super.key,
    required this.category,
    required this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final controller = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    controller.loadQuiz(widget.category, widget.difficulty);
  }

  void _onNext() {
    bool finished = controller.nextQuestion();

    if (finished) {
      Get.off(() => ResultScreen(
        score: controller.score.value,
        total: controller.questions.length,
        correct: controller.correct.value,
        wrong: controller.wrong.value,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: QuizOproBackground(
            child: Center(
              child: CircularProgressIndicator(color: Colors.cyan),
            ),
          ),
        );
      }

      if (controller.questions.isEmpty) {
        return const Scaffold(
          body: QuizOproBackground(
            child: Center(
              child: Text(
                "No Questions Found",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }

      final question =
      controller.questions[controller.currentIndex.value];

      return Scaffold(
        body: QuizOproBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  /// 🔙 Back
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔝 Header
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/onboardingscreen.png',
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "⏱ 00:${controller.seconds.value.toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🟡 Difficulty
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.difficulty.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ❓ Question
                  Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "${controller.currentIndex.value + 1} / ${controller.questions.length}",
                    style: const TextStyle(color: Colors.white54),
                  ),

                  const SizedBox(height: 25),

                  /// 🧠 Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            controller.selectedIndex.value == index;
                        bool isCorrect =
                            index == question.correctAnswer;

                        Color borderColor =
                        controller.isAnswered.value && isCorrect
                            ? Colors.green
                            : (controller.isAnswered.value &&
                            isSelected &&
                            !isCorrect
                            ? Colors.red
                            : (isSelected
                            ? Colors.cyan
                            : Colors.white24));

                        return GestureDetector(
                          onTap: () =>
                              controller.selectOption(index),
                          child: Container(
                            margin:
                            const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color:
                              Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                  color: borderColor, width: 2),
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    question.options[index],
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                                if (controller.isAnswered.value &&
                                    isCorrect)
                                  const Icon(Icons.check,
                                      color: Colors.green),
                                if (controller.isAnswered.value &&
                                    isSelected &&
                                    !isCorrect)
                                  const Icon(Icons.close,
                                      color: Colors.red),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            bool finished = controller.nextQuestion();
                            if (finished) {
                              Get.off(() => ResultScreen(
                                score: controller.score.value,
                                total: controller.questions.length,
                                correct: controller.correct.value,
                                wrong: controller.wrong.value,
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.grey.shade800,
                          ),
                          child: const Text("SKIP"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isAnswered.value
                              ? _onNext
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            controller.isAnswered.value
                                ? Colors.cyan
                                : Colors.grey,
                          ),
                          child: const Text("NEXT"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}