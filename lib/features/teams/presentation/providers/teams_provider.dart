import 'package:flutter/foundation.dart';
import '../../domain/entities/team.dart';

class TeamsProvider extends ChangeNotifier {
  List<Team> _teams = [];
  Set<String> _followedTeamIds = {};
  bool _isLoading = false;
  String? _error;
  
  // Search functionality
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'name'; // name, followers, winRate, trending

  List<Team> get teams => _teams;
  Set<String> get followedTeamIds => _followedTeamIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Search getters
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  List<Team> get followedTeams =>
      _teams.where((team) => _followedTeamIds.contains(team.id)).toList();
  List<Team> get trendingTeams =>
      _teams.where((team) => team.followersCount > 500).toList();
  
  // Filtered and sorted teams based on search criteria
  List<Team> get filteredTeams {
    List<Team> filtered = _teams;
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((team) {
        return team.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               team.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               team.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((team) => team.category == _selectedCategory).toList();
    }
    
    // Sort teams
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'followers':
        filtered.sort((a, b) => b.followersCount.compareTo(a.followersCount));
        break;
      case 'winRate':
        filtered.sort((a, b) => b.winRate.compareTo(a.winRate));
        break;
      case 'trending':
        filtered.sort((a, b) => (b.followersCount * b.winRate).compareTo(a.followersCount * a.winRate));
        break;
    }
    
    return filtered;
  }
  
  // Get unique categories for filter dropdown
  List<String> get categories {
    final categories = _teams.map((team) => team.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  Future<void> loadTeams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _teams = _generateMockTeams();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load teams: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTeams() async {
    await loadTeams();
  }

  void toggleFollow(String teamId) {
    if (_followedTeamIds.contains(teamId)) {
      _followedTeamIds.remove(teamId);
    } else {
      _followedTeamIds.add(teamId);
    }
    notifyListeners();
  }
  
  // Search methods
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }
  
  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _sortBy = 'name';
    notifyListeners();
  }
  
  bool isFollowing(String teamId) {
    return _followedTeamIds.contains(teamId);
  }

  Team? getTeamById(String teamId) {
    try {
      return _teams.firstWhere((team) => team.id == teamId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<Team> _generateMockTeams() {
    final now = DateTime.now();

    return [
      Team(
        id: '1',
        name: 'TechCorp Sales Team',
        logo: '🏢',
        category: 'Sales',
        description:
            'Leading technology sales team with a proven track record of exceeding targets and driving innovation in the B2B space.',
        followersCount: 1247,
        winRate: 78.5,
        totalChallenges: 24,
        wonChallenges: 19,
        totalEarnings: 2500000,
        foundedDate: DateTime(2020, 3, 15),
        members: ['Sarah Johnson', 'Mike Chen', 'Emily Rodriguez', 'David Kim'],
        location: 'San Francisco, CA',
        website: 'techcorp.com',
        performanceStats: [
          const PerformanceStat(
            metric: 'Q4 Sales Target',
            value: 85.2,
            unit: '%',
            period: 'Current Quarter',
            change: 12.5,
          ),
          const PerformanceStat(
            metric: 'Customer Acquisition',
            value: 156,
            unit: 'new clients',
            period: 'This Month',
            change: 8.3,
          ),
          const PerformanceStat(
            metric: 'Revenue Growth',
            value: 34.7,
            unit: '%',
            period: 'YoY',
            change: 5.2,
          ),
        ],
        recentActivities: [
          RecentActivity(
            id: '1',
            title: 'Q4 Sales Challenge Started',
            description: 'New \$2M target challenge launched',
            timestamp: now.subtract(const Duration(hours: 2)),
            type: ActivityType.challengeStarted,
            challengeId: '1',
          ),
          RecentActivity(
            id: '2',
            title: 'Milestone Reached',
            description: 'Achieved 75% of Q4 target',
            timestamp: now.subtract(const Duration(days: 1)),
            type: ActivityType.milestoneReached,
          ),
        ],
      ),
      Team(
        id: '2',
        name: 'StartupXYZ',
        logo: '🚀',
        category: 'Product',
        description:
            'Innovative startup focused on AI-powered solutions for modern businesses. Known for rapid product development and market disruption.',
        followersCount: 892,
        winRate: 65.0,
        totalChallenges: 18,
        wonChallenges: 12,
        totalEarnings: 1800000,
        foundedDate: DateTime(2021, 8, 10),
        members: ['Alex Thompson', 'Lisa Wang', 'James Wilson', 'Maria Garcia'],
        location: 'Austin, TX',
        website: 'startupxyz.io',
        performanceStats: [
          const PerformanceStat(
            metric: 'Product Downloads',
            value: 7500,
            unit: 'downloads',
            period: 'This Week',
            change: 23.1,
          ),
          const PerformanceStat(
            metric: 'User Engagement',
            value: 89.3,
            unit: '%',
            period: 'Daily Active',
            change: 15.7,
          ),
          const PerformanceStat(
            metric: 'Market Share',
            value: 12.4,
            unit: '%',
            period: 'Industry',
            change: 3.8,
          ),
        ],
        recentActivities: [
          RecentActivity(
            id: '3',
            title: 'Product Launch Challenge',
            description: 'AI product launch with 10K download target',
            timestamp: now.subtract(const Duration(hours: 5)),
            type: ActivityType.challengeStarted,
            challengeId: '2',
          ),
          RecentActivity(
            id: '4',
            title: 'New Team Member',
            description: 'Maria Garcia joined as Lead Developer',
            timestamp: now.subtract(const Duration(days: 3)),
            type: ActivityType.newMember,
          ),
        ],
      ),
      Team(
        id: '3',
        name: 'ShopMax',
        logo: '🛒',
        category: 'E-commerce',
        description:
            'E-commerce giant revolutionizing online shopping with cutting-edge technology and exceptional customer service.',
        followersCount: 2156,
        winRate: 82.3,
        totalChallenges: 31,
        wonChallenges: 26,
        totalEarnings: 4200000,
        foundedDate: DateTime(2019, 1, 20),
        members: [
          'Robert Smith',
          'Jennifer Lee',
          'Michael Brown',
          'Amanda Davis',
          'Chris Taylor',
        ],
        location: 'New York, NY',
        website: 'shopmax.com',
        performanceStats: [
          const PerformanceStat(
            metric: 'Customer Acquisition',
            value: 32000,
            unit: 'new customers',
            period: 'This Month',
            change: 18.9,
          ),
          const PerformanceStat(
            metric: 'Conversion Rate',
            value: 4.7,
            unit: '%',
            period: 'Website',
            change: 2.1,
          ),
          const PerformanceStat(
            metric: 'Average Order Value',
            value: 89.50,
            unit: '\$',
            period: 'Per Order',
            change: 7.3,
          ),
        ],
        recentActivities: [
          RecentActivity(
            id: '5',
            title: 'Customer Acquisition Challenge',
            description: '50K new customers target for this month',
            timestamp: now.subtract(const Duration(hours: 8)),
            type: ActivityType.challengeStarted,
            challengeId: '3',
          ),
          RecentActivity(
            id: '6',
            title: 'Milestone Reached',
            description: 'Reached 30K new customers this month',
            timestamp: now.subtract(const Duration(days: 2)),
            type: ActivityType.milestoneReached,
          ),
        ],
      ),
      Team(
        id: '4',
        name: 'PayFlow',
        logo: '💳',
        category: 'FinTech',
        description:
            'Revolutionary fintech startup making financial services accessible to everyone through innovative payment solutions.',
        followersCount: 743,
        winRate: 71.4,
        totalChallenges: 14,
        wonChallenges: 10,
        totalEarnings: 1500000,
        foundedDate: DateTime(2022, 5, 12),
        members: ['Daniel Park', 'Sophie Martin', 'Kevin Liu', 'Rachel Green'],
        location: 'Seattle, WA',
        website: 'payflow.finance',
        performanceStats: [
          const PerformanceStat(
            metric: 'Transaction Volume',
            value: 850000,
            unit: '\$',
            period: 'Daily',
            change: 25.6,
          ),
          const PerformanceStat(
            metric: 'User Growth',
            value: 45.2,
            unit: '%',
            period: 'Monthly',
            change: 12.8,
          ),
          const PerformanceStat(
            metric: 'Security Score',
            value: 98.7,
            unit: '%',
            period: 'Compliance',
            change: 1.2,
          ),
        ],
        recentActivities: [
          RecentActivity(
            id: '7',
            title: 'IPO Challenge Started',
            description: 'Targeting \$1B valuation for public offering',
            timestamp: now.subtract(const Duration(hours: 12)),
            type: ActivityType.challengeStarted,
            challengeId: '4',
          ),
          RecentActivity(
            id: '8',
            title: 'Security Milestone',
            description: 'Achieved 98.7% security compliance score',
            timestamp: now.subtract(const Duration(days: 5)),
            type: ActivityType.milestoneReached,
          ),
        ],
      ),
      Team(
        id: '5',
        name: 'SocialConnect',
        logo: '📱',
        category: 'Social Media',
        description:
            'Next-generation social media platform connecting people through meaningful interactions and community building.',
        followersCount: 1689,
        winRate: 69.2,
        totalChallenges: 22,
        wonChallenges: 15,
        totalEarnings: 2100000,
        foundedDate: DateTime(2021, 11, 8),
        members: ['Emma Wilson', 'Tom Anderson', 'Nina Patel', 'Carlos Mendez'],
        location: 'Los Angeles, CA',
        website: 'socialconnect.app',
        performanceStats: [
          const PerformanceStat(
            metric: 'Daily Active Users',
            value: 680000,
            unit: 'users',
            period: 'Current',
            change: 19.4,
          ),
          const PerformanceStat(
            metric: 'Engagement Rate',
            value: 67.8,
            unit: '%',
            period: 'User Activity',
            change: 8.9,
          ),
          const PerformanceStat(
            metric: 'Content Creation',
            value: 12500,
            unit: 'posts/day',
            period: 'Average',
            change: 22.1,
          ),
        ],
        recentActivities: [
          RecentActivity(
            id: '9',
            title: 'User Engagement Challenge',
            description: 'Targeting 1M daily active users',
            timestamp: now.subtract(const Duration(hours: 6)),
            type: ActivityType.challengeStarted,
            challengeId: '5',
          ),
          RecentActivity(
            id: '10',
            title: 'Feature Announcement',
            description: 'New video calling feature launched',
            timestamp: now.subtract(const Duration(days: 4)),
            type: ActivityType.announcement,
          ),
        ],
      ),
      Team(
        id: '6',
        name: 'CloudSoft',
        logo: '☁️',
        category: 'SaaS',
        description:
            'Enterprise SaaS solutions provider helping businesses scale with cloud-based productivity and collaboration tools.',
        followersCount: 1123,
        winRate: 76.9,
        totalChallenges: 26,
        wonChallenges: 20,
        totalEarnings: 3200000,
        foundedDate: DateTime(2020, 7, 3),
        members: [
          'Andrew Johnson',
          'Sarah Kim',
          'Mark Thompson',
          'Lisa Chen',
          'Ryan Davis',
        ],
        location: 'Boston, MA',
        website: 'cloudsoft.tech',
        performanceStats: [
          const PerformanceStat(
            metric: 'Revenue Growth',
            value: 200,
            unit: '%',
            period: 'YoY',
            change: 45.2,
          ),
          const PerformanceStat(
            metric: 'Customer Retention',
            value: 94.5,
            unit: '%',
            period: 'Annual',
            change: 3.7,
          ),
          const PerformanceStat(
            metric: 'API Calls',
            value: 2.5,
            unit: 'M calls/day',
            period: 'Average',
            change: 31.8,
          ),
        ],
        recentActivities: [
          RecentActivity(
            id: '11',
            title: 'Revenue Growth Challenge',
            description: '200% YoY growth target challenge',
            timestamp: now.subtract(const Duration(hours: 4)),
            type: ActivityType.challengeStarted,
            challengeId: '6',
          ),
          RecentActivity(
            id: '12',
            title: 'Customer Milestone',
            description: 'Reached 10,000 enterprise customers',
            timestamp: now.subtract(const Duration(days: 6)),
            type: ActivityType.milestoneReached,
          ),
        ],
      ),
    ];
  }
}
