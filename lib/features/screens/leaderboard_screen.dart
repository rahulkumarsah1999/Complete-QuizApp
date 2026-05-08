import '../../widgets/podium_card.dart';
import 'package:flutter/material.dart';
import '../../services/leaderboard_service.dart';
import '../models/leaderboard_model.dart';
import '../../widgets/sparkle_bg.dart';
import '../../widgets/leaderboard_row.dart';

class LeaderboardScreen extends StatefulWidget {
  final String playerName;

  const LeaderboardScreen({
    super.key,
    this.playerName = 'You',
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  late TabController _tabController;
  late AnimationController _staggerController;

  final List<String> _filters = ['All', 'Technical', 'Science', 'History', 'Aptitude'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    // await LeaderboardService.seedDemoData();
    final entries = _selectedFilter == 'All'
        ? await LeaderboardService.getAll()
        : await LeaderboardService.getByCategory(_selectedFilter);

    // Sort entries by points (descending)
    entries.sort((a, b) => b.points.compareTo(a.points));

    setState(() {
      _entries = entries;
      _isLoading = false;
    });
    _staggerController.forward(from: 0);
  }

  Future<void> _applyFilter(String filter) async {
    setState(() {
      _selectedFilter = filter;
      _isLoading = true;
    });
    await _loadData();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }
  @override
  void dispose() {
    _tabController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF061640),
                  Color(0xFF0A3D7A),
                  Color(0xFF0D6B8A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ── Sparkle layer ──
           SparkleBackground(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildFilterChips(),
                _buildTopThreePodium(),
                _buildListHeader(),
                Expanded(child: _buildList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🏆 Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Top players this week',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          // Refresh button
          GestureDetector(
            onTap: () => _applyFilter(_selectedFilter),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border:
                Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.refresh,
                  color: Colors.cyanAccent, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = _filters[i];
          final selected = _selectedFilter == f;
          return GestureDetector(
            onTap: () => _applyFilter(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.cyanAccent
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? Colors.cyanAccent
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white70,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopThreePodium() {
    if (_isLoading || _entries.length < 3) return const SizedBox(height: 8);

    final top3 = _entries.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(child: PodiumCard(entry: top3[1], rank: 2, height: 90)),
          const SizedBox(width: 8),
          // 1st place
          Expanded(child: PodiumCard(entry: top3[0], rank: 1, height: 120)),
          const SizedBox(width: 8),
          // 3rd place
          Expanded(child: PodiumCard(entry: top3[2], rank: 3, height: 72)),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        children: [
          const Text('#',
              style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          const Expanded(
              child: Text('PLAYER',
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.bold))),
          const Text('POINTS',
              style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }

    if (_entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌌', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'No scores yet for $_selectedFilter',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Play a quiz to appear here!',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        final isMe = entry.name == widget.playerName;

        final delay = (index * 60).clamp(0, 600);
        final animation = CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            delay / 900,
            (delay + 300) / 900,
            curve: Curves.easeOut,
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: Opacity(opacity: animation.value, child: child),
          ),
          child: LeaderboardRow(
            entry: entry,
            rank: index + 1,
            isMe: isMe,
          ),
        );
      },
    );
  }
}
