import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/background.dart';
import '../controllers/history_controller.dart';
import 'quiz_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());
   HistoryScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return QuizOproBackground(
      child: Obx(() => controller.historyList.isEmpty
          ? const Center(child: Text("No history yet!", style: TextStyle(color: Colors.white)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.historyList.length,
        itemBuilder: (context, index) {
          final item = controller.historyList[index];
          return ListTile(
            title: Text(item.category, style: const TextStyle(color: Colors.white)),
            subtitle: Text("Score: ${item.score}/${item.total}", style: const TextStyle(color: Colors.cyanAccent)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () => Get.to(() => QuizDetailScreen(attempt: item)),
          );
        },
      )),
    );
  }
}