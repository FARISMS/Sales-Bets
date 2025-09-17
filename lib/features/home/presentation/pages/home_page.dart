import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/challenges_provider.dart';
import '../widgets/challenge_card.dart';
import '../widgets/trending_section.dart';
import '../../../betting/presentation/widgets/wallet_display.dart';
import '../../../teams/presentation/widgets/followed_teams_widget.dart';
import '../../../leaderboard/presentation/providers/leaderboard_provider.dart';
import '../../../teams/presentation/widgets/trending_teams_widget.dart';
import '../../../teams/presentation/providers/teams_provider.dart';
import '../../../leaderboard/presentation/widgets/leaderboard_widget.dart';
import '../../../betting/presentation/widgets/demo_betting_widget.dart';
import '../../../betting/presentation/widgets/compact_wallet_widget.dart';
import '../../../notifications/presentation/widgets/notification_list_widget.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load data when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChallengesProvider>().loadChallenges();
      context.read<LeaderboardProvider>().loadLeaderboard();
      context.read<TeamsProvider>().loadTeams();
      context.read<NotificationProvider>().addDemoNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales Bets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          const SizedBox(width: 16),
          const CompactWalletWidget(),
          const SizedBox(width: 12),
          const NotificationListWidget(),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<ChallengesProvider>(
        builder: (context, challengesProvider, child) {
          if (challengesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (challengesProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    challengesProvider.error!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      challengesProvider.refreshChallenges();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: challengesProvider.refreshChallenges,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to Sales Bets! 🎯',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bet on business success, win rewards, never lose your stake!',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${challengesProvider.activeChallenges.length} Active Challenges',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Wallet Display
                  const WalletDisplay(),

                  const SizedBox(height: 20),

                  // Demo Betting Widget
                  Consumer<ChallengesProvider>(
                    builder: (context, challengesProvider, child) {
                      final demoChallenge = challengesProvider.challenges
                          .where((challenge) => challenge.isDemo)
                          .firstOrNull;

                      if (demoChallenge != null) {
                        return Column(
                          children: [
                            DemoBettingWidget(challenge: demoChallenge),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Followed Teams Section
                  const FollowedTeamsWidget(),

                  const SizedBox(height: 20),

                  // Enhanced Trending Teams Section
                  const TrendingTeamsWidget(),

                  const SizedBox(height: 20),

                  // Leaderboard Section
                  const LeaderboardWidget(),

                  const SizedBox(height: 20),

                  // Original Trending Section (Challenges)
                  const TrendingSection(),

                  const SizedBox(height: 24),

                  // Active Challenges Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Challenges',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all challenges
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Challenges List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: challengesProvider.activeChallenges.length,
                    itemBuilder: (context, index) {
                      final challenge =
                          challengesProvider.activeChallenges[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ChallengeCard(challenge: challenge),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
