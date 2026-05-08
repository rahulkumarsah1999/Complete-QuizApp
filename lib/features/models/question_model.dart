enum Difficulty { easy, medium, hard }

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final Difficulty difficulty;
  final String category;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.category,
  });

  int get points {
    switch (difficulty) {
      case Difficulty.hard:
        return 30;
      case Difficulty.medium:
        return 20;
      case Difficulty.easy:
        return 10;
    }
  }

  factory Question.fromJson(
      Map<String, dynamic> json, Difficulty diff, String cat) {
    final options = List<String>.from(json['options'] ?? []);
    final rawAnswer = json['correctAnswer'];
    final correctAnswer =
    (rawAnswer is int && rawAnswer >= 0 && rawAnswer < options.length)
        ? rawAnswer
        : 0;

    return Question(
      question: (json['question'] ?? '').toString().trim(),
      options: options.map((o) => o.trim()).toList(),
      correctAnswer: correctAnswer,
      difficulty: diff,
      category: cat,
    );
  }


  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'difficulty': difficulty.name,
    'category': category,
  };


  Question copyWith({
    String? question,
    List<String>? options,
    int? correctAnswer,
    Difficulty? difficulty,
    String? category,
  }) {
    return Question(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
    );
  }

  @override
  String toString() =>
      'Question(category: $category, difficulty: ${difficulty.name}, '
          'correctAnswer: $correctAnswer, question: $question)';
}