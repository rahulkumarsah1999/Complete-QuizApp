import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_with_gemini/features/screens/history_screen.dart';
import 'package:quiz_app_with_gemini/widgets/searchbar.dart';
import '../../widgets/background.dart';
import '../../widgets/home_widget.dart';
import '../controllers/search_controller.dart';
import '../controllers/history_controller.dart';
import '../models/question_model.dart';
import '../screens/quizscreen.dart';
import 'category.dart';
import '../screens/leaderboard_screen.dart';
import 'loginpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MySearchController searchController = Get.put(MySearchController());
  final HistoryController historyController = Get.put(HistoryController(), permanent: true);

  int currentIndex = 0;
  late List<Widget> _pages;

  final List<Map<String, dynamic>> categories = [
    {"name": "Technical", "icon": Icons.code, "color": Colors.orangeAccent},
    {"name": "Science", "icon": Icons.science, "color": Colors.cyanAccent},
    {"name": "History", "icon": Icons.history_edu, "color": Colors.greenAccent},
    {"name": "Aptitude", "icon": Icons.psychology, "color": Colors.purpleAccent},
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      const SizedBox(),
      CategoryScreen(
        categories: categories,
        onCategorySelected: (name) => _showDifficultyPicker(context, name),
      ),
       LeaderboardScreen(),
       HistoryScreen(),
    ];
  }

  void _showDifficultyPicker(BuildContext context, String categoryName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select Difficulty",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...Difficulty.values.map((diff) => _buildDifficultyOption(context, diff, categoryName)),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyOption(BuildContext context, Difficulty diff, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Get.to(() => QuizScreen(category: category, difficulty: diff.name));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(diff.name.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const Icon(Icons.arrow_forward_ios, color: Colors.cyanAccent, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _buildBottomNav(),
      body: currentIndex == 0 ? _homeUI() : _pages[currentIndex],
    );
  }

  Widget _homeUI() {
    return QuizOproBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              const Text("Ready for your\nnext challenge?",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              const SearchBarWidget(),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => setState(() => currentIndex = 1),
                child: const SectionTitle("CATEGORIES"),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => CategoryCard(
                    category: categories[index],
                    onTap: () => _showDifficultyPicker(context, categories[index]['name']),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const SectionTitle("CONTINUE PLAYING"),
              const SizedBox(height: 15),
              _buildContinuePlayingCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinuePlayingCard() {
    return Obx(() {
      final history = historyController.historyList;

      // No history yet — prompt to start
      if (history.isEmpty) {
        return GestureDetector(
          onTap: () => setState(() => currentIndex = 1),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(colors: [
                Colors.blueAccent.withValues(alpha: 0.5),
                Colors.cyan.withValues(alpha: 0.3),
              ]),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Text('🚀', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('No quizzes yet!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Tap to pick a category and start playing',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ]),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.cyanAccent, size: 16),
              ],
            ),
          ),
        );
      }

      // Last attempted quiz
      final last = history.first;
      final correct = last.selectedAnswers.asMap().entries
          .where((e) => e.key < last.questions.length && e.value == last.questions[e.key].correctAnswer)
          .length;
      final pct = last.total == 0 ? 0.0 : (correct / last.total).clamp(0.0, 1.0);

      return GestureDetector(
        onTap: () => _showDifficultyPicker(context, last.category),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(colors: [
              Colors.blueAccent.withValues(alpha: 0.8),
              Colors.cyan.withValues(alpha: 0.6),
            ]),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text('⚡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(last.category,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text('$correct / ${last.total}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: pct, color: Colors.white, backgroundColor: Colors.white24, minHeight: 7),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Text('${(pct * 100).round()}% accuracy',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              const Text('Play again →',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
          ]),
        ),
      );
    });
  }

  Widget _buildHeader() => Row(children: [
    Image.asset('assets/images/onboardingscreen.png', height: 40),
    const SizedBox(width: 10),
    Image.asset('assets/images/title.png', width: 100),
    const Spacer(),
    _buildProfileIcon(),
  ]);

  Widget _buildProfileIcon() => GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (context) => Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 80, right: 20),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FirebaseAuth.instance.currentUser?.displayName ?? "No Name",
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  FirebaseAuth.instance.currentUser?.email ?? "No Email",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);

                            await FirebaseAuth.instance.signOut();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.logout, color: Colors.redAccent),
                              SizedBox(width: 10),
                              Text("Logout",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white38),
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: Colors.white, size: 26),
        ),
      );

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.white10),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(6, 0))],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _navItem(Icons.home_filled, 0),
              _navItem(Icons.grid_view_rounded, 1),
              _navItem(Icons.emoji_events_outlined, 2),
              _navItem(Icons.history_sharp, 3),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: isSelected ? Colors.cyanAccent.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Icon(icon, color: isSelected ? Colors.cyanAccent : Colors.white54, size: 26),
      ),
    );
  }
}