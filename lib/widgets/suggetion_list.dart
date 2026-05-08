import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/controllers/search_controller.dart';

class SuggestionList extends StatelessWidget {
  const SuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    final searchC = Get.find<MySearchController>();

    return Obx(() {
      if (searchC.suggestions.isEmpty) return const SizedBox();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1A35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 16),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: searchC.suggestions.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final isLast = i == searchC.suggestions.length - 1;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: Icon(
                    s.isCategory ? Icons.category_outlined : Icons.auto_awesome,
                    color: s.isCategory ? Colors.cyanAccent : Colors.purpleAccent,
                    size: 18,
                  ),
                  title: Text(
                    s.label,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: Text(
                    s.isCategory ? 'Category' : 'AI-generated quiz',
                    style: TextStyle(
                      color: s.isCategory
                          ? Colors.cyanAccent.withOpacity(0.6)
                          : Colors.purpleAccent.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  onTap: () => searchC.selectSuggestion(s),
                ),
                if (!isLast)
                  const Divider(
                      color: Colors.white10, height: 1, indent: 16, endIndent: 16),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}