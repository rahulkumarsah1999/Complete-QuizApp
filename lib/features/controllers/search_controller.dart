import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/quizscreen.dart';

class MySearchController extends GetxController {
  var isExpanded = false.obs;
  var query = ''.obs;
  // PUBLIC class — accessible from SuggestionList and SearchBarWidget
  var suggestions = <SearchSuggestion>[].obs;

  Timer? _debounce;

  final List<String> categories = [
    "Technical",
    "Science",
    "History",
    "Aptitude",
    "Reasoning",
    "General Knowledge",
    "Programming",
    "English",
    "Innovations",
  ];

  void toggleSearch() => isExpanded.value = !isExpanded.value;

  void onSearchChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _generateSuggestions(value);
    });
  }

  void _generateSuggestions(String input) {
    if (input.trim().isEmpty) {
      suggestions.clear();
      return;
    }

    final lower = input.toLowerCase();
    final List<SearchSuggestion> result = [];

    for (final cat in categories) {
      if (cat.toLowerCase().contains(lower)) {
        result.add(SearchSuggestion(label: cat, isCategory: true));
      }
    }

    final alreadyExact = result.any((s) => s.label.toLowerCase() == lower);
    if (!alreadyExact) {
      result.add(SearchSuggestion(
        label: 'Quiz on "$input"',
        isCategory: false,
        customTopic: input.trim(),
      ));
    }

    suggestions.value = result;
  }

  void selectSuggestion(SearchSuggestion suggestion) {
    query.value = suggestion.label;
    suggestions.clear();
    _navigateToQuiz(
      topic: suggestion.customTopic ?? suggestion.label,
      isCategory: suggestion.isCategory,
    );
  }

  void onSearchSubmit(String value) {
    if (value.trim().isEmpty) return;
    suggestions.clear();
    final isCategory = categories.any(
          (c) => c.toLowerCase() == value.toLowerCase(),
    );
    _navigateToQuiz(topic: value.trim(), isCategory: isCategory);
  }

  void _navigateToQuiz({required String topic, required bool isCategory}) {
    log(' Search navigate → topic: $topic, isCategory: $isCategory');
    Get.bottomSheet(
      _DifficultyPicker(topic: topic, isCategory: isCategory),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}

class SearchSuggestion {
  final String label;
  final bool isCategory;
  final String? customTopic;

  const SearchSuggestion({
    required this.label,
    required this.isCategory,
    this.customTopic,
  });
}

class _DifficultyPicker extends StatelessWidget {
  final String topic;
  final bool isCategory;

  const _DifficultyPicker({required this.topic, required this.isCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Icon(
              isCategory ? Icons.category_outlined : Icons.auto_awesome,
              color: Colors.cyanAccent, size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isCategory ? topic : 'AI Quiz: $topic',
                style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          if (!isCategory)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                '✦ AI will generate questions on this topic',
                style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'SELECT DIFFICULTY',
            style: TextStyle(
              color: Colors.white38, fontSize: 11,
              letterSpacing: 1, fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...['easy', 'medium', 'hard'].map((diff) {
            final colors = {
              'easy': Colors.greenAccent,
              'medium': Colors.orangeAccent,
              'hard': Colors.redAccent,
            };
            final icons = {
              'easy': Icons.sentiment_satisfied_alt,
              'medium': Icons.sentiment_neutral,
              'hard': Icons.local_fire_department,
            };
            final color = colors[diff]!;
            return GestureDetector(
              onTap: () {
                Get.back();
                Get.to(() => QuizScreen(category: topic, difficulty: diff));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Row(children: [
                  Icon(icons[diff], color: color, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    diff[0].toUpperCase() + diff.substring(1),
                    style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color: color.withValues(alpha: 0.6), size: 14),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }
}