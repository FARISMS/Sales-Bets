import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/onboarding_page.dart';

class OnboardingProvider extends ChangeNotifier {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  bool _isOnboardingCompleted = false;
  bool _isLoading = false;
  int _currentPageIndex = 0;
  List<OnboardingPage> _pages = [];

  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;
  int get currentPageIndex => _currentPageIndex;
  List<OnboardingPage> get pages => _pages;
  OnboardingPage? get currentPage =>
      _pages.isNotEmpty && _currentPageIndex < _pages.length
      ? _pages[_currentPageIndex]
      : null;
  bool get isLastPage => _currentPageIndex == _pages.length - 1;
  bool get isFirstPage => _currentPageIndex == 0;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load onboarding completion status
      await _loadOnboardingStatus();

      // Generate onboarding pages
      _pages = _generateOnboardingPages();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
    _isOnboardingCompleted = true;
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompletedKey);
    _isOnboardingCompleted = false;
    _currentPageIndex = 0;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _currentPageIndex++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPageIndex > 0) {
      _currentPageIndex--;
      notifyListeners();
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _currentPageIndex = index;
      notifyListeners();
    }
  }

  List<OnboardingPage> _generateOnboardingPages() {
    return [
      const OnboardingPage(
        id: 'welcome',
        title: 'Welcome to Sales Bets!',
        description:
            'The revolutionary platform where you can win big but never lose your stake. Experience the future of business betting.',
        imagePath: 'assets/images/onboarding/welcome.png',
        iconData: '🎯',
        features: [
          'Win money on business challenges',
          'Never lose your initial stake',
          'Follow your favorite teams',
          'Watch live streams and events',
        ],
        type: OnboardingPageType.welcome,
      ),
      const OnboardingPage(
        id: 'concept',
        title: 'Win But Never Lose',
        description:
            'Our unique "no-loss" betting system ensures you can only gain, never lose. Your stake is always protected!',
        imagePath: 'assets/images/onboarding/concept.png',
        iconData: '🛡️',
        features: [
          'Your stake is always returned',
          'Only winnings are added to your balance',
          'Risk-free betting experience',
          'Guaranteed protection of your credits',
        ],
        type: OnboardingPageType.concept,
      ),
      const OnboardingPage(
        id: 'betting',
        title: 'Smart Betting System',
        description:
            'Place bets on business challenges with confidence. Watch your credits grow as teams achieve their goals.',
        imagePath: 'assets/images/onboarding/betting.png',
        iconData: '💰',
        features: [
          'Bet on Q4 sales targets',
          'Support product launches',
          'Back marketing campaigns',
          'Earn rewards on success',
        ],
        type: OnboardingPageType.betting,
      ),
      const OnboardingPage(
        id: 'rewards',
        title: 'Amazing Rewards',
        description:
            'Celebrate your wins with spectacular animations and watch your earnings grow with every successful bet.',
        imagePath: 'assets/images/onboarding/rewards.png',
        iconData: '🎉',
        features: [
          'Confetti celebrations on wins',
          'Animated reward displays',
          'Real-time earnings updates',
          'Beautiful win experiences',
        ],
        type: OnboardingPageType.rewards,
      ),
      const OnboardingPage(
        id: 'teams',
        title: 'Follow Your Teams',
        description:
            'Stay connected with your favorite business teams and athletes. Get real-time updates and performance insights.',
        imagePath: 'assets/images/onboarding/teams.png',
        iconData: '👥',
        features: [
          'Follow top-performing teams',
          'Real-time performance stats',
          'Team activity notifications',
          'Detailed team profiles',
        ],
        type: OnboardingPageType.teams,
      ),
      const OnboardingPage(
        id: 'streaming',
        title: 'Live Streaming',
        description:
            'Watch live business events, team meetings, and challenge updates. Chat with other users in real-time.',
        imagePath: 'assets/images/onboarding/streaming.png',
        iconData: '📺',
        features: [
          'Live business events',
          'Real-time chat with users',
          'Team meeting streams',
          'Interactive viewing experience',
        ],
        type: OnboardingPageType.streaming,
      ),
      const OnboardingPage(
        id: 'complete',
        title: 'You\'re All Set!',
        description:
            'Ready to start your journey? Place your first bet and experience the thrill of winning without the fear of losing.',
        imagePath: 'assets/images/onboarding/complete.png',
        iconData: '🚀',
        features: [
          'Start betting immediately',
          'Explore trending challenges',
          'Follow your favorite teams',
          'Join the community',
        ],
        type: OnboardingPageType.complete,
      ),
    ];
  }
}
