import 'dart:async';
import 'package:get/get.dart';
import 'package:quiz_app_with_gemini/features/models/question_model.dart';
import '../../services/gemini_service.dart';
import '../../services/leaderboard_service.dart';
import '../models/leaderboard_model.dart';
import '../models/quiz_attempt_model.dart';
import 'history_controller.dart';

class QuizController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = true.obs;

  var currentIndex = 0.obs;
  var selectedIndex = RxnInt();
  var isAnswered = false.obs;

  var score = 0.obs;
  var correct = 0.obs;
  var wrong = 0.obs;

  var seconds = 20.obs;
  Timer? timer;

  List<int?> selectedAnswers = [];
  String category = "";
  String difficulty = "";

  // Track quiz source for UI badge
  QuizSource? quizSource;

  Future<void> loadQuiz(String category, String difficulty) async {
    this.category = category;
    this.difficulty = difficulty;

    isLoading.value = true;

    try {
      // FIX: safely parse string → Difficulty enum instead of unsafe cast
      final Difficulty diffEnum = Difficulty.values.byName(
        difficulty.toLowerCase(),
      );

      // FIX: generateQuiz returns QuizResult, extract .questions
      final result = await GeminiService.generateQuiz(category, diffEnum);

      questions.value = result.questions;
      quizSource = result.source;
      selectedAnswers = List.filled(result.questions.length, null);
      isLoading.value = false;
      startTimer();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Failed to load quiz',
        e.toString().contains('No internet')
            ? 'No internet and no cached questions yet. Play once online first.'
            : e.toString().contains('429')
            ? 'Quota exceeded. Please wait a minute and try again.'
            : 'Could not load questions. Check your connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void startTimer() {
    timer?.cancel();
    seconds.value = 20;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        handleTimeOut();
      }
    });
  }

  void handleTimeOut() {
    timer?.cancel();
    isAnswered.value = true;
  }

  void selectOption(int index) {
    if (isAnswered.value) return;

    selectedIndex.value = index;
    selectedAnswers[currentIndex.value] = index;
    isAnswered.value = true;
    timer?.cancel();

    if (index == questions[currentIndex.value].correctAnswer) {
      score.value += 10;
      correct.value++;
    } else {
      wrong.value++;
    }
  }

  bool nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedIndex.value = null;
      isAnswered.value = false;
      startTimer();
      return false;
    } else {
      saveToHistory();
      return true;
    }
  }

  void saveToHistory() async {
    final historyController = Get.find<HistoryController>();

    historyController.addAttempt(
      QuizAttempt(
        category: category,
        score: score.value,
        total: questions.length,
        date: DateTime.now(),
        questions: questions,
        selectedAnswers: selectedAnswers,
      ),
    );

    await LeaderboardService.addEntry(
      LeaderboardEntry(
        name: "Rahul",
        score: correct.value, // FIX: use correct.value (number right) not score÷10
        totalQuestions: questions.length,
        category: category,
        difficulty: difficulty,
        playedAt: DateTime.now(),
      ),
    );
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}