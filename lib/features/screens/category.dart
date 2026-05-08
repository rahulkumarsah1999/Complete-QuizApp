import 'package:flutter/material.dart';
import 'package:quiz_app_with_gemini/widgets/background.dart';
import '../../core/utils/app_constants.dart';
import '../../widgets/home_widget.dart';

class CategoryScreen extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryScreen({super.key, required this.onCategorySelected, required List<Map<String, dynamic>> categories});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCategories = AppConstants.categories;

  void filterCategories(String query) {
    final results = AppConstants.categories.where((cat) {
      return cat['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCategories = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: QuizOproBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                /// 🔍 SEARCH BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: filterCategories,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.white38),
                      hintText: "Search category...",
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 📚 CATEGORY GRID
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () => widget.onCategorySelected(category['name']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}