class LeaderboardEntry {
  final String name;
  final int score;        // number of correct answers (0–10)
  final int totalQuestions;
  final String category;
  final String difficulty;
  final DateTime playedAt;

  const LeaderboardEntry({
    required this.name,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.difficulty,
    required this.playedAt,
  });

  int get percentage =>
      totalQuestions == 0 ? 0 : ((score / totalQuestions) * 100).round();

  /// 1 point per correct answer, all difficulties same.
  /// Only Hard difficulty entries are saved to the leaderboard (enforced in LeaderboardService).
  int get points => score;

  String get difficultyLabel =>
      difficulty[0].toUpperCase() + difficulty.substring(1).toLowerCase();

  Map<String, dynamic> toJson() => {
    'name': name,
    'score': score,
    'totalQuestions': totalQuestions,
    'category': category,
    'difficulty': difficulty,
    'playedAt': playedAt.toIso8601String(),
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        name: json['name'] ?? 'Player',
        score: json['score'] ?? 0,
        totalQuestions: json['totalQuestions'] ?? 10,
        category: json['category'] ?? 'General',
        difficulty: json['difficulty'] ?? 'hard',
        playedAt: DateTime.tryParse(json['playedAt'] ?? '') ?? DateTime.now(),
      );
}