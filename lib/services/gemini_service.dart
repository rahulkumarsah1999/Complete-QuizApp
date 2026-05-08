import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quiz_app_with_gemini/config/api_key.dart';
import '../features/models/question_model.dart';
import 'quizcache_service.dart';

enum QuizSource { ai, cache }

class QuizResult {
  final List<Question> questions;
  final QuizSource source;
  final String? cacheAge;

  const QuizResult({
    required this.questions,
    required this.source,
    this.cacheAge,
  });
}

class GeminiService {
  static const String _apiKey = ApiKeys.openRouterApiKey;

  static const String _baseUrl = "https://openrouter.ai/api/v1/chat/completions";

  static const String _model = "google/gemini-2.0-flash-lite-001";

  static Future<QuizResult> generateQuiz(
      String category, Difficulty difficulty) async {

    final isOnline = await _hasInternet();

    if (isOnline) {
      try {
        final questions = await _fetchFromAI(category, difficulty);
        await QuizCacheService.saveQuestions(category, difficulty, questions);
        return QuizResult(questions: questions, source: QuizSource.ai);
      } catch (e) {
        log(' AI fetch failed, falling back to cache: $e');
      }
    } else {
      log(' No internet — loading from cache');
    }

    final cached = await QuizCacheService.loadQuestions(category, difficulty);
    if (cached != null && cached.isNotEmpty) {
      final age = await QuizCacheService.getCacheAge(category, difficulty);
      return QuizResult(
        questions: cached,
        source: QuizSource.cache,
        cacheAge: age,
      );
    }

    throw Exception(
      isOnline
          ? 'Could not load questions and no offline cache found. Please try again.'
          : 'No internet and no cached questions for $category / ${difficulty.name}. '
          'Connect to the internet to download this quiz first.',
    );
  }

  static Future<List<Question>> _fetchFromAI(
      String category, Difficulty difficulty) async {
    final seed = DateTime.now().millisecondsSinceEpoch % 9999;

    final prompt = """
Generate 10 UNIQUE multiple choice questions about $category at a ${difficulty.name} difficulty level.
Variation seed: $seed — use this to ensure a fresh, different set of questions every time.

STRICT RULES:
- Return ONLY a raw JSON array.
- No markdown, no triple backticks, no explanations.
- Every question must be different — be creative and varied.
- Use this exact structure:
[
  {
    "question": "The question text here?",
    "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
    "correctAnswer": 0
  }
]
Note: correctAnswer must be an integer (0-3) representing the index in the options array.
""";

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
        // Optional but recommended by OpenRouter for app identification
        "HTTP-Referer": "https://github.com/your-app",
        "X-Title": "QuizMind App",
      },
      body: jsonEncode({
        "model": _model,
        "messages": [
          {
            "role": "user",
            "content": prompt,
          }
        ],
        "temperature": 1.0,
        "max_tokens": 2048,
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      log("❌ OpenRouter Error ${response.statusCode}: ${response.body}");
      throw Exception("API error ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    // OpenRouter returns OpenAI-compatible format:
    // data["choices"][0]["message"]["content"]
    final choices = data["choices"];
    if (choices == null || choices.isEmpty) {
      throw Exception("No choices in OpenRouter response");
    }

    String text = choices[0]["message"]["content"] ?? '';
    log("✅ OpenRouter raw response: $text");

    // Strip markdown fences just in case
    text = text.replaceAll("```json", "").replaceAll("```", "").trim();

    final int start = text.indexOf('[');
    final int end = text.lastIndexOf(']') + 1;
    if (start == -1 || end == 0) {
      throw Exception("No JSON array found in response");
    }

    final List<dynamic> parsed = jsonDecode(text.substring(start, end));
    if (parsed.isEmpty) throw Exception("Empty question list from model");

    return parsed
        .map((q) => Question.fromJson(q as Map<String, dynamic>, difficulty, category))
        .toList();
  }

  static Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}