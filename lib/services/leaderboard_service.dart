import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/models/leaderboard_model.dart';

class LeaderboardService {
  static const String _key = 'leaderboard_entries';

  /// Save a new quiz result — only Hard difficulty is eligible for leaderboard
  static Future<void> addEntry(LeaderboardEntry entry) async {
    // FIX: silently ignore non-hard entries
    if (entry.difficulty.toLowerCase() != 'hard') return;
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAll();
    existing.add(entry);

    // Keep only top 100 entries sorted by points
    existing.sort((a, b) => b.points.compareTo(a.points));
    final trimmed = existing.take(100).toList();

    final jsonList = trimmed.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  /// Get all entries sorted by points (descending)
  static Future<List<LeaderboardEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final List<dynamic> parsed = jsonDecode(raw);
      final entries = parsed
          .map((j) => LeaderboardEntry.fromJson(j as Map<String, dynamic>))
          .toList();
      entries.sort((a, b) => b.points.compareTo(a.points));
      return entries;
    } catch (_) {
      return [];
    }
  }

  /// Get top N entries
  static Future<List<LeaderboardEntry>> getTop(int n) async {
    final all = await getAll();
    return all.take(n).toList();
  }

  /// Get entries filtered by category
  static Future<List<LeaderboardEntry>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((e) => e.category == category).toList();
  }

  /// Get personal best for a category+difficulty
  static Future<LeaderboardEntry?> getPersonalBest(
      String playerName, String category, String difficulty) async {
    final all = await getAll();
    final filtered = all
        .where((e) =>
    e.name == playerName &&
        e.category == category &&
        e.difficulty == difficulty)
        .toList();
    if (filtered.isEmpty) return null;
    filtered.sort((a, b) => b.points.compareTo(a.points));
    return filtered.first;
  }

  /// Clear all entries
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}