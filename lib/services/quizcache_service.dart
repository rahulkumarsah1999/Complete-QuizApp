import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/models/question_model.dart';

class QuizCacheService {
  static const String _cachePrefix = 'quiz_cache_';
  static const String _timestampPrefix = 'quiz_ts_';

  // Cache is valid for 24 hours
  static const Duration _cacheTTL = Duration(hours: 24);

  /// Cache key: e.g. "quiz_cache_science_medium"
  static String _cacheKey(String category, Difficulty difficulty) =>
      '$_cachePrefix${category.toLowerCase()}_${difficulty.name}';

  static String _timestampKey(String category, Difficulty difficulty) =>
      '$_timestampPrefix${category.toLowerCase()}_${difficulty.name}';

  /// Save questions to local cache
  static Future<void> saveQuestions(
      String category, Difficulty difficulty, List<Question> questions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _cacheKey(category, difficulty);
      final tsKey = _timestampKey(category, difficulty);

      final jsonList = questions.map((q) => q.toJson()).toList();
      await prefs.setString(key, jsonEncode(jsonList));
      await prefs.setInt(tsKey, DateTime.now().millisecondsSinceEpoch);

      log('✅ Cached ${questions.length} questions for $category / ${difficulty.name}');
    } catch (e) {
      log('⚠️ Failed to cache questions: $e');
    }
  }

  /// Load questions from cache. Returns null if no cache or cache is stale.
  static Future<List<Question>?> loadQuestions(
      String category, Difficulty difficulty) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _cacheKey(category, difficulty);
      final tsKey = _timestampKey(category, difficulty);

      final cached = prefs.getString(key);
      final timestamp = prefs.getInt(tsKey);

      if (cached == null || timestamp == null) {
        log('📭 No cache found for $category / ${difficulty.name}');
        return null;
      }

      // Check if cache is still fresh
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cachedAt);
      if (age > _cacheTTL) {
        log('⏰ Cache expired for $category / ${difficulty.name} (age: ${age.inHours}h)');
        return null;
      }

      final List<dynamic> jsonList = jsonDecode(cached);
      final questions = jsonList
          .map((j) => Question.fromJson(j as Map<String, dynamic>, difficulty, category))
          .toList();

      log('📦 Loaded ${questions.length} cached questions for $category / ${difficulty.name}');
      return questions;
    } catch (e) {
      log('⚠️ Failed to load cache: $e');
      return null;
    }
  }

  /// Check if valid (non-expired) cache exists
  static Future<bool> hasFreshCache(
      String category, Difficulty difficulty) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tsKey = _timestampKey(category, difficulty);
      final timestamp = prefs.getInt(tsKey);

      if (timestamp == null) return false;

      final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cachedAt);
      return age <= _cacheTTL;
    } catch (_) {
      return false;
    }
  }

  /// Clear cache for a specific category+difficulty
  static Future<void> clearCache(String category, Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey(category, difficulty));
    await prefs.remove(_timestampKey(category, difficulty));
    log('🗑️ Cleared cache for $category / ${difficulty.name}');
  }

  /// Clear ALL cached quizzes
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cachePrefix) || key.startsWith(_timestampPrefix)) {
        await prefs.remove(key);
      }
    }
    log('🗑 Cleared all quiz cache');
  }

  /// Get cache age as a human-readable string (e.g. "2 hours ago")
  static Future<String?> getCacheAge(
      String category, Difficulty difficulty) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tsKey = _timestampKey(category, difficulty);
      final timestamp = prefs.getInt(tsKey);
      if (timestamp == null) return null;

      final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cachedAt);

      if (age.inMinutes < 60) return '${age.inMinutes}m ago';
      if (age.inHours < 24) return '${age.inHours}h ago';
      return '${age.inDays}d ago';
    } catch (_) {
      return null;
    }
  }
}