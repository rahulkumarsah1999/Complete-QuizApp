import 'package:flutter/material.dart';

import '../features/models/leaderboard_model.dart';

class PodiumCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final double height;

  const PodiumCard(
      {super.key, required this.entry, required this.rank, required this.height});

  static const _medals = {1: '🥇', 2: '🥈', 3: '🥉'};
  static const _glows = {
    1: Colors.amber,
    2: Colors.grey,
    3: Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final glow = _glows[rank]!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_medals[rank]!, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          entry.name,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.points} pts',
          style: TextStyle(
              color: glow, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                glow.withValues(alpha: 0.4),
                glow.withValues(alpha: 0.15),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: glow.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                  color: glow.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1)
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                  color: glow,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}