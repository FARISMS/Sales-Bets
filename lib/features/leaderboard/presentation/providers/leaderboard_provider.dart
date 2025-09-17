import 'package:flutter/foundation.dart';
import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = false;
  String? _error;
  String _currentUserId = 'current_user_1'; // Mock current user ID

  List<LeaderboardEntry> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get top 10 users for main widget
  List<LeaderboardEntry> get topUsers => _leaderboard.take(10).toList();

  // Get top 5 users for compact view
  List<LeaderboardEntry> get topFiveUsers => _leaderboard.take(5).toList();

  // Get current user's rank
  LeaderboardEntry? get currentUserRank =>
      _leaderboard.where((entry) => entry.id == _currentUserId).firstOrNull;

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _leaderboard = _generateMockLeaderboard();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load leaderboard: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshLeaderboard() async {
    await loadLeaderboard();
  }

  List<LeaderboardEntry> _generateMockLeaderboard() {
    return [
      LeaderboardEntry(
        id: 'user_1',
        username: 'alex_sales_pro',
        displayName: 'Alex Chen',
        avatar: '👨‍💼',
        totalEarnings: 125000.0,
        totalBets: 47,
        winRate: 89.4,
        rank: 1,
        badge: '🏆',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_2',
        username: 'sarah_tech_queen',
        displayName: 'Sarah Johnson',
        avatar: '👩‍💻',
        totalEarnings: 118500.0,
        totalBets: 52,
        winRate: 86.5,
        rank: 2,
        badge: '🥈',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_3',
        username: 'mike_startup_guru',
        displayName: 'Mike Rodriguez',
        avatar: '👨‍🚀',
        totalEarnings: 112000.0,
        totalBets: 38,
        winRate: 84.2,
        rank: 3,
        badge: '🥉',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_4',
        username: 'emma_fintech',
        displayName: 'Emma Thompson',
        avatar: '👩‍💼',
        totalEarnings: 98500.0,
        totalBets: 41,
        winRate: 82.9,
        rank: 4,
        badge: '💎',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_5',
        username: 'david_ecommerce',
        displayName: 'David Kim',
        avatar: '👨‍💻',
        totalEarnings: 92000.0,
        totalBets: 35,
        winRate: 81.7,
        rank: 5,
        badge: '⭐',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_6',
        username: 'lisa_saas_expert',
        displayName: 'Lisa Wang',
        avatar: '👩‍🚀',
        totalEarnings: 87500.0,
        totalBets: 43,
        winRate: 79.1,
        rank: 6,
        badge: '🔥',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_7',
        username: 'james_ai_master',
        displayName: 'James Wilson',
        avatar: '👨‍💼',
        totalEarnings: 82000.0,
        totalBets: 39,
        winRate: 77.8,
        rank: 7,
        badge: '🚀',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_8',
        username: 'anna_cloud_architect',
        displayName: 'Anna Martinez',
        avatar: '👩‍💻',
        totalEarnings: 78500.0,
        totalBets: 36,
        winRate: 76.4,
        rank: 8,
        badge: '☁️',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_9',
        username: 'robert_data_scientist',
        displayName: 'Robert Brown',
        avatar: '👨‍🔬',
        totalEarnings: 74000.0,
        totalBets: 33,
        winRate: 75.8,
        rank: 9,
        badge: '📊',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_10',
        username: 'maria_product_manager',
        displayName: 'Maria Garcia',
        avatar: '👩‍💼',
        totalEarnings: 69500.0,
        totalBets: 40,
        winRate: 74.2,
        rank: 10,
        badge: '📈',
        isCurrentUser: false,
      ),
      // Current user (ranked lower)
      LeaderboardEntry(
        id: _currentUserId,
        username: 'current_user',
        displayName: 'You',
        avatar: '👤',
        totalEarnings: 45000.0,
        totalBets: 28,
        winRate: 71.4,
        rank: 15,
        badge: '🎯',
        isCurrentUser: true,
      ),
      LeaderboardEntry(
        id: 'user_11',
        username: 'tom_marketing_guru',
        displayName: 'Tom Anderson',
        avatar: '👨‍💼',
        totalEarnings: 65000.0,
        totalBets: 31,
        winRate: 73.5,
        rank: 11,
        badge: '📢',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_12',
        username: 'sophie_ux_designer',
        displayName: 'Sophie Lee',
        avatar: '👩‍🎨',
        totalEarnings: 61000.0,
        totalBets: 29,
        winRate: 72.1,
        rank: 12,
        badge: '🎨',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_13',
        username: 'kevin_devops',
        displayName: 'Kevin Taylor',
        avatar: '👨‍💻',
        totalEarnings: 58000.0,
        totalBets: 34,
        winRate: 70.6,
        rank: 13,
        badge: '⚙️',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        id: 'user_14',
        username: 'rachel_qa_lead',
        displayName: 'Rachel White',
        avatar: '👩‍🔬',
        totalEarnings: 52000.0,
        totalBets: 26,
        winRate: 69.2,
        rank: 14,
        badge: '🔍',
        isCurrentUser: false,
      ),
    ];
  }
}
