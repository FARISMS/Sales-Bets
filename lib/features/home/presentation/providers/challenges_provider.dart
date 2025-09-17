import 'package:flutter/foundation.dart';
import '../../domain/entities/business_challenge.dart';

class ChallengesProvider extends ChangeNotifier {
  List<BusinessChallenge> _challenges = [];
  bool _isLoading = false;
  String? _error;

  List<BusinessChallenge> get challenges => _challenges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<BusinessChallenge> get activeChallenges =>
      _challenges.where((challenge) => challenge.isActive).toList();

  List<BusinessChallenge> get trendingChallenges => _challenges
      .where((challenge) => challenge.participantsCount > 100)
      .toList();

  Future<void> loadChallenges() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for business challenges
      _challenges = _generateMockChallenges();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load challenges: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshChallenges() async {
    await loadChallenges();
  }

  void addChallenge(BusinessChallenge challenge) {
    _challenges.insert(0, challenge);
    notifyListeners();
  }

  void updateChallenge(BusinessChallenge updatedChallenge) {
    final index = _challenges.indexWhere((c) => c.id == updatedChallenge.id);
    if (index != -1) {
      _challenges[index] = updatedChallenge;
      notifyListeners();
    }
  }

  List<BusinessChallenge> _generateMockChallenges() {
    final now = DateTime.now();

    return [
      // Demo 5-minute challenge for no-loss betting
      BusinessChallenge(
        id: 'demo_5min',
        title: '🚀 DEMO: 5-Minute No-Loss Bet',
        description:
            'Try our revolutionary no-loss betting! Place a bet and win rewards without losing your stake. Perfect for testing the platform!',
        teamName: 'Demo Team Alpha',
        teamLogo: '🎯',
        targetAmount: 1000,
        currentAmount: 750,
        startDate: now,
        endDate: now.add(const Duration(minutes: 5)),
        status: ChallengeStatus.active,
        odds: 2.0,
        participantsCount: 42,
        category: 'Demo',
        isDemo: true, // Add demo flag
      ),
      BusinessChallenge(
        id: '1',
        title: 'Q4 Sales Target Challenge',
        description:
            'TechCorp aims to achieve \$2M in Q4 sales. Join the bet and win if they succeed!',
        teamName: 'TechCorp Sales Team',
        teamLogo: '🏢',
        targetAmount: 2000000,
        currentAmount: 1500000,
        startDate: now.subtract(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 15)),
        status: ChallengeStatus.active,
        odds: 1.8,
        participantsCount: 245,
        category: 'Sales',
      ),
      BusinessChallenge(
        id: '2',
        title: 'Product Launch Success',
        description:
            'StartupXYZ launching their new AI product. Will they hit 10K downloads in first week?',
        teamName: 'StartupXYZ',
        teamLogo: '🚀',
        targetAmount: 10000,
        currentAmount: 7500,
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 4)),
        status: ChallengeStatus.active,
        odds: 2.1,
        participantsCount: 189,
        category: 'Product',
      ),
      BusinessChallenge(
        id: '3',
        title: 'Customer Acquisition Goal',
        description:
            'E-commerce giant targeting 50K new customers this month. High stakes, high rewards!',
        teamName: 'ShopMax',
        teamLogo: '🛒',
        targetAmount: 50000,
        currentAmount: 32000,
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 20)),
        status: ChallengeStatus.active,
        odds: 1.5,
        participantsCount: 312,
        category: 'Marketing',
      ),
      BusinessChallenge(
        id: '4',
        title: 'IPO Success Prediction',
        description:
            'FinTech startup going public. Will they achieve their target valuation?',
        teamName: 'PayFlow',
        teamLogo: '💳',
        targetAmount: 1000000000, // $1B valuation
        currentAmount: 850000000,
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 25)),
        status: ChallengeStatus.active,
        odds: 3.2,
        participantsCount: 156,
        category: 'Finance',
      ),
      BusinessChallenge(
        id: '5',
        title: 'User Engagement Milestone',
        description:
            'Social media app targeting 1M daily active users. Join the community bet!',
        teamName: 'SocialConnect',
        teamLogo: '📱',
        targetAmount: 1000000,
        currentAmount: 680000,
        startDate: now.subtract(const Duration(days: 20)),
        endDate: now.add(const Duration(days: 10)),
        status: ChallengeStatus.active,
        odds: 1.9,
        participantsCount: 278,
        category: 'Social',
      ),
      BusinessChallenge(
        id: '6',
        title: 'Revenue Growth Challenge',
        description:
            'SaaS company aiming for 200% YoY growth. High risk, high reward opportunity!',
        teamName: 'CloudSoft',
        teamLogo: '☁️',
        targetAmount: 5000000,
        currentAmount: 4200000,
        startDate: now.subtract(const Duration(days: 8)),
        endDate: now.add(const Duration(days: 22)),
        status: ChallengeStatus.active,
        odds: 2.5,
        participantsCount: 201,
        category: 'SaaS',
      ),
    ];
  }
}
