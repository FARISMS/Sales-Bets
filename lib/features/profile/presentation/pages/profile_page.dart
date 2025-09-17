import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/firebase_auth_provider.dart';
import '../../../leaderboard/presentation/widgets/leaderboard_widget.dart';
import '../../../leaderboard/presentation/providers/leaderboard_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../../betting/presentation/providers/betting_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../core/theme/widgets/theme_toggle_widget.dart';
import '../../../../core/theme/widgets/theme_selection_dialog.dart';
import '../widgets/profile_wallet_widget.dart';
import '../widgets/betting_history_widget.dart';
import '../widgets/profile_notifications_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load data when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().loadLeaderboard();
      context.read<BettingProvider>().loadBettingHistory();
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [ThemeToggleWidget(isCompact: true), const SizedBox(width: 8)],
      ),
      body: Consumer<FirebaseAuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 30, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.userEmail ?? 'User',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Wallet Section
                const ProfileWalletWidget(),

                const SizedBox(height: 16),

                // Betting History Section
                const BettingHistoryWidget(),

                const SizedBox(height: 16),

                // Notifications Section
                const ProfileNotificationsWidget(),

                const SizedBox(height: 16),

                // Leaderboard Section
                const LeaderboardWidget(),

                const SizedBox(height: 16),

                // Profile Options
                Column(
                  children: [
                    _buildProfileOption(
                      context,
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'App preferences and settings',
                      onTap: () {
                        // TODO: Navigate to settings
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.palette,
                      title: 'Theme Settings',
                      subtitle: 'Choose your preferred theme',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ThemeSelectionDialog(),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () {
                        // TODO: Navigate to help
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.refresh,
                      title: 'Reset Onboarding',
                      subtitle: 'Show onboarding screens again',
                      onTap: () async {
                        await context
                            .read<OnboardingProvider>()
                            .resetOnboarding();
                        if (mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/onboarding');
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          authProvider.logout();
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
