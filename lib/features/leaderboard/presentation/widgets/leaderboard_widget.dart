import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';
import '../pages/full_leaderboard_page.dart';
import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaderboardProvider>(
      builder: (context, leaderboardProvider, child) {
        if (leaderboardProvider.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (leaderboardProvider.error != null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    leaderboardProvider.error!,
                    style: const TextStyle(color: Colors.red),
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
            ),
          );
        }

        final topUsers = leaderboardProvider.topFiveUsers;
        final currentUserRank = leaderboardProvider.currentUserRank;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Leaderboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FullLeaderboardPage(),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Top 5 users as list
                if (topUsers.isNotEmpty) ...[
                  ...topUsers
                      .take(5)
                      .map((user) => _buildLeaderboardEntry(context, user)),
                  const SizedBox(height: 16),
                ],

                // Current user rank (if not in top 5)
                if (currentUserRank != null && currentUserRank.rank > 5) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildCurrentUserRank(context, currentUserRank),
                ],
              ],
            ),
          ),
        );
      },
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
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: user.rank <= 3
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${user.rank}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: user.rank <= 3 ? Colors.amber[800] : Colors.grey[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          Text(user.avatar, style: const TextStyle(fontSize: 20)),
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: user.isCurrentUser
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                    if (user.badge.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(user.badge, style: const TextStyle(fontSize: 12)),
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user.winRate}% win rate',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRank(BuildContext context, LeaderboardEntry user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(
            'Your Rank: #${user.rank}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Spacer(),
          Text(
            '\$${_formatEarnings(user.totalEarnings)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
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
