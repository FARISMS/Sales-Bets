import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';
import '../../domain/entities/leaderboard_entry.dart';

class FullLeaderboardPage extends StatefulWidget {
  const FullLeaderboardPage({super.key});

  @override
  State<FullLeaderboardPage> createState() => _FullLeaderboardPageState();
}

class _FullLeaderboardPageState extends State<FullLeaderboardPage> {
  @override
  void initState() {
    super.initState();
    // Load leaderboard data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LeaderboardProvider>();
      if (provider.leaderboard.isEmpty) {
        provider.loadLeaderboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<LeaderboardProvider>().refreshLeaderboard();
            },
          ),
        ],
      ),
      body: Consumer<LeaderboardProvider>(
        builder: (context, leaderboardProvider, child) {
          if (leaderboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (leaderboardProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    leaderboardProvider.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      leaderboardProvider.refreshLeaderboard();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allUsers = leaderboardProvider.leaderboard;
          final currentUserRank = leaderboardProvider.currentUserRank;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top 3 users with special styling
                if (allUsers.isNotEmpty) ...[
                  _buildTopThreeUsers(context, allUsers.take(3).toList()),
                  const SizedBox(height: 24),
                ],

                // All users list
                if (allUsers.isNotEmpty) ...[
                  const Text(
                    'All Rankings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...allUsers.map(
                    (user) => _buildLeaderboardEntry(context, user),
                  ),
                ],

                // Current user rank (if not in top 10)
                if (currentUserRank != null && currentUserRank.rank > 10) ...[
                  const SizedBox(height: 24),
                  _buildCurrentUserRank(context, currentUserRank),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopThreeUsers(
    BuildContext context,
    List<LeaderboardEntry> topThree,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Top 3',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // 2nd place
                if (topThree.length > 1)
                  Expanded(child: _buildPodiumUser(context, topThree[1], 2)),

                // 1st place (center, larger)
                Expanded(
                  flex: 2,
                  child: _buildPodiumUser(context, topThree[0], 1),
                ),

                // 3rd place
                if (topThree.length > 2)
                  Expanded(child: _buildPodiumUser(context, topThree[2], 3)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumUser(
    BuildContext context,
    LeaderboardEntry user,
    int position,
  ) {
    Color backgroundColor;
    Color textColor;

    switch (position) {
      case 1:
        backgroundColor = Colors.amber.withOpacity(0.1);
        textColor = Colors.amber[800]!;
        break;
      case 2:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        break;
      case 3:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[800]!;
        break;
      default:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[800]!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rank badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$position',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Avatar
          Text(user.avatar, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),

          // Name
          Text(
            user.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Earnings
          Text(
            '\$${_formatEarnings(user.totalEarnings)}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardEntry(BuildContext context, LeaderboardEntry user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: user.isCurrentUser
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: user.isCurrentUser
            ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: user.rank <= 3
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${user.rank}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: user.rank <= 3 ? Colors.amber[800] : Colors.grey[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          Text(user.avatar, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: user.isCurrentUser
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                    if (user.badge.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(user.badge, style: const TextStyle(fontSize: 14)),
                    ],
                  ],
                ),
                Text(
                  '@${user.username}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Earnings
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${_formatEarnings(user.totalEarnings)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user.winRate}% win rate',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRank(BuildContext context, LeaderboardEntry user) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            Text(
              'Your Rank: #${user.rank}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Spacer(),
            Text(
              '\$${_formatEarnings(user.totalEarnings)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEarnings(double earnings) {
    if (earnings >= 1000000) {
      return '${(earnings / 1000000).toStringAsFixed(1)}M';
    } else if (earnings >= 1000) {
      return '${(earnings / 1000).toStringAsFixed(1)}K';
    } else {
      return earnings.toStringAsFixed(0);
    }
  }
}
