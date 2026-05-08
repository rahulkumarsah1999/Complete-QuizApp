
import 'package:flutter/material.dart';

import '../features/models/leaderboard_model.dart';

class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isMe;

  const LeaderboardRow({ super.key,
    required this.entry,
    required this.rank,
    required this.isMe,
  });

  Color get _diffColor {
    switch (entry.difficulty.toLowerCase()) {
      case 'hard':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe
            ? Colors.cyanAccent.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? Colors.cyanAccent.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
          width: isMe ? 1.5 : 1,
        ),
        boxShadow: isMe
            ? [
          BoxShadow(
              color: Colors.cyanAccent.withValues(alpha: 0.15),
              blurRadius: 10)
        ]
            : [],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 28,
            child: Text(
              rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '$rank',
              style: TextStyle(
                color: rank <= 3 ? null : Colors.white38,
                fontSize: rank <= 3 ? 18 : 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),

          // Avatar circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isMe
                    ? [Colors.cyanAccent, Colors.blue]
                    : [
                  Colors.purpleAccent.withValues(alpha: 0.6),
                  Colors.blue.withValues(alpha: 0.6)
                ],
              ),
            ),
            child: Center(
              child: Text(
                entry.name[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        color: isMe ? Colors.cyanAccent : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('YOU',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    Text(
                      entry.category,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11),
                    ),
                    const Text(' · ',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 11)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: _diffColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.difficulty[0].toUpperCase() +
                            entry.difficulty.substring(1),
                        style: TextStyle(
                            color: _diffColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Score + points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.points}',
                style: TextStyle(
                  color: isMe ? Colors.cyanAccent : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${entry.score}/${entry.totalQuestions} correct',
                style: const TextStyle(
                    color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}