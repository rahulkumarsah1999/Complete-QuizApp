import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_attempt_model.dart';

class HistoryController extends GetxController {
  static const String _key = 'quiz_history';

  var historyList = <QuizAttempt>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromDisk();
  }

  /// Load persisted history from SharedPreferences on startup
  Future<void> _loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        final List<dynamic> parsed = jsonDecode(raw);
        final entries = parsed
            .map((j) => QuizAttempt.fromJson(j as Map<String, dynamic>))
            .toList();
        historyList.assignAll(entries);
        log('📋 Loaded ${entries.length} history entries from disk');
      }
    } catch (e) {
      log('⚠️ Failed to load history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new attempt and persist it
  Future<void> addAttempt(QuizAttempt attempt) async {
    historyList.insert(0, attempt); // newest first
    await _saveToDisk();
    log('✅ History saved: ${attempt.category} score=${attempt.score}');
  }

  /// Delete a single attempt by index
  Future<void> deleteAttempt(int index) async {
    if (index < 0 || index >= historyList.length) return;
    historyList.removeAt(index);
    await _saveToDisk();
  }

  /// Clear all history
  Future<void> clearAll() async {
    historyList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    log('🗑️ History cleared');
  }

  /// Persist current list to SharedPreferences
  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Keep last 50 attempts
      final trimmed = historyList.take(50).toList();
      final jsonList = trimmed.map((e) => e.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    } catch (e) {
      log('⚠️ Failed to save history: $e');
    }
  }

  /// Filter by category
  List<QuizAttempt> getByCategory(String category) =>
      historyList.where((e) => e.category == category).toList();

  /// Overall stats
  Map<String, dynamic> get stats {
    if (historyList.isEmpty) return {};
    final total = historyList.length;
    final totalScore = historyList.fold<int>(0, (s, e) => s + e.score);
    final totalQs = historyList.fold<int>(0, (s, e) => s + e.total);
    final avgPct =
    totalQs == 0 ? 0 : ((totalScore / (totalQs * 10)) * 100).round();
    final best = historyList
        .map((e) => e.percentage)
        .reduce((a, b) => a > b ? a : b);
    final catCount = <String, int>{};
    for (final e in historyList) {
      catCount[e.category] = (catCount[e.category] ?? 0) + 1;
    }
    final favCat =
        catCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return {
      'totalQuizzes': total,
      'avgAccuracy': avgPct,
      'bestScore': best,
      'favouriteCategory': favCat,
    };
  }
}