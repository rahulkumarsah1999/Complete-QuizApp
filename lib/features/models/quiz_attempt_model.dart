import 'package:quiz_app_with_gemini/features/models/question_model.dart';

class QuizAttempt {
  final String category;
  final int score;
  final int total;
  final DateTime date;
  final List<Question> questions;
  final List<int?> selectedAnswers;

  QuizAttempt({
    required this.category,
    required this.score,
    required this.total,
    required this.date,
    required this.questions,
    required this.selectedAnswers,
  });

  int get percentage => total == 0 ? 0 : ((score / (total * 10)) * 100).round();

  int get correctCount => selectedAnswers
      .asMap()
      .entries
      .where((e) =>
  e.key < questions.length &&
      e.value == questions[e.key].correctAnswer)
      .length;

  Map<String, dynamic> toJson() => {
    'category': category,
    'score': score,
    'total': total,
    'date': date.toIso8601String(),
    'questions': questions
        .map((q) => {
      'question': q.question,
      'options': q.options,
      'correctAnswer': q.correctAnswer,
      'difficulty': q.difficulty.name,
      'category': q.category,
    })
        .toList(),
    'selectedAnswers': selectedAnswers,
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    final rawQuestions = (json['questions'] as List<dynamic>? ?? []);
    final questions = rawQuestions.map((q) {
      final map = q as Map<String, dynamic>;
      final diff = Difficulty.values.byName(
        (map['difficulty'] as String? ?? 'easy').toLowerCase(),
      );
      return Question(
        question: map['question'] ?? '',
        options: List<String>.from(map['options'] ?? []),
        correctAnswer: map['correctAnswer'] ?? 0,
        difficulty: diff,
        category: map['category'] ?? '',
      );
    }).toList();

    final rawAnswers = (json['selectedAnswers'] as List<dynamic>? ?? []);
    final selectedAnswers =
    rawAnswers.map((e) => e == null ? null : e as int).toList();

    return QuizAttempt(
      category: json['category'] ?? '',
      score: json['score'] ?? 0,
      total: json['total'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      questions: questions,
      selectedAnswers: selectedAnswers,
    );
  }
}