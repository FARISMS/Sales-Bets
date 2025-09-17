import 'package:flutter/foundation.dart';
import '../../domain/entities/bet.dart';
import '../../domain/entities/user_wallet.dart';

class BettingProvider extends ChangeNotifier {
  UserWallet _wallet = UserWallet(
    userId: '1',
    totalCredits: 1000.0, // Starting credits
    availableCredits: 1000.0,
    stakedCredits: 0.0,
    totalWinnings: 0.0,
    lastUpdated: DateTime.now(),
  );

  List<Bet> _bets = [];
  bool _isLoading = false;
  String? _error;

  UserWallet get wallet => _wallet;
  List<Bet> get bets => _bets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Bet> get activeBets =>
      _bets.where((bet) => bet.status == BetStatus.pending).toList();
  List<Bet> get wonBets =>
      _bets.where((bet) => bet.status == BetStatus.won).toList();
  List<Bet> get lostBets =>
      _bets.where((bet) => bet.status == BetStatus.lost).toList();
  
  List<Bet> get bettingHistory => _bets;

  // No-loss betting logic: stake credits remain constant, only gains increment total
  Future<bool> placeBet({
    required String challengeId,
    required String teamName,
    required double stakeAmount,
    required double odds,
  }) async {
    if (stakeAmount <= 0) {
      _error = 'Stake amount must be greater than 0';
      notifyListeners();
      return false;
    }

    if (stakeAmount > _wallet.availableCredits) {
      _error =
          'Insufficient credits. Available: \$${_wallet.availableCredits.toStringAsFixed(2)}';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new bet
      final newBet = Bet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _wallet.userId,
        challengeId: challengeId,
        teamName: teamName,
        stakeAmount: stakeAmount,
        odds: odds,
        placedAt: DateTime.now(),
        status: BetStatus.pending,
      );

      // Add bet to list
      _bets.insert(0, newBet);

      // Update wallet - NO-LOSS LOGIC: stake credits remain constant
      _wallet = _wallet.copyWith(
        availableCredits: _wallet.availableCredits - stakeAmount,
        stakedCredits: _wallet.stakedCredits + stakeAmount,
        lastUpdated: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to place bet: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Simulate bet resolution (for demo purposes)
  Future<void> resolveBet(String betId, bool won) async {
    final betIndex = _bets.indexWhere((bet) => bet.id == betId);
    if (betIndex == -1) return;

    final bet = _bets[betIndex];
    final winAmount = won ? bet.stakeAmount * bet.odds : 0.0;

    // Update bet status
    _bets[betIndex] = Bet(
      id: bet.id,
      userId: bet.userId,
      challengeId: bet.challengeId,
      teamName: bet.teamName,
      stakeAmount: bet.stakeAmount,
      odds: bet.odds,
      placedAt: bet.placedAt,
      status: won ? BetStatus.won : BetStatus.lost,
      winAmount: winAmount,
    );

    // Update wallet - NO-LOSS LOGIC: stake credits are returned + winnings
    _wallet = _wallet.copyWith(
      availableCredits: _wallet.availableCredits + bet.stakeAmount + winAmount,
      stakedCredits: _wallet.stakedCredits - bet.stakeAmount,
      totalCredits:
          _wallet.totalCredits + winAmount, // Only winnings increase total
      totalWinnings: _wallet.totalWinnings + winAmount,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();
  }

  // Simulate challenge completion for demo
  Future<void> simulateChallengeCompletion(
    String challengeId,
    bool teamWon,
  ) async {
    final activeBetsForChallenge = _bets
        .where(
          (bet) =>
              bet.challengeId == challengeId && bet.status == BetStatus.pending,
        )
        .toList();

    for (final bet in activeBetsForChallenge) {
      await resolveBet(bet.id, teamWon);
    }
  }

  // Simulate bet result with real-time updates
  Future<void> simulateBetResult(String betId, bool isWin) async {
    // Update bet status locally (Firebase integration can be added later)
    await resolveBet(betId, isWin);
  }

  // Add credits (for demo purposes)
  void addCredits(double amount) {
    _wallet = _wallet.copyWith(
      totalCredits: _wallet.totalCredits + amount,
      availableCredits: _wallet.availableCredits + amount,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  Future<void> loadBettingHistory() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate loading betting history
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate some mock betting history
      _bets = _generateMockBets();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load betting history: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  List<Bet> _generateMockBets() {
    final now = DateTime.now();
    return [
      Bet(
        id: '1',
        userId: '1',
        challengeId: 'Q4 Sales Target',
        teamName: 'Sales Team A',
        stakeAmount: 100.0,
        odds: 2.0,
        placedAt: now.subtract(const Duration(hours: 2)),
        status: BetStatus.won,
        winAmount: 200.0,
      ),
      Bet(
        id: '2',
        userId: '1',
        challengeId: 'Product Launch',
        teamName: 'Marketing Team',
        stakeAmount: 50.0,
        odds: 1.5,
        placedAt: now.subtract(const Duration(days: 1)),
        status: BetStatus.pending,
      ),
      Bet(
        id: '3',
        userId: '1',
        challengeId: 'Customer Satisfaction',
        teamName: 'Support Team',
        stakeAmount: 75.0,
        odds: 3.0,
        placedAt: now.subtract(const Duration(days: 2)),
        status: BetStatus.lost,
      ),
    ];
  }

  // Get bet history for a specific challenge
  List<Bet> getBetsForChallenge(String challengeId) {
    return _bets.where((bet) => bet.challengeId == challengeId).toList();
  }

  // Get user's bet for a specific challenge
  Bet? getUserBetForChallenge(String challengeId) {
    try {
      return _bets.firstWhere((bet) => bet.challengeId == challengeId);
    } catch (e) {
      return null;
    }
  }

  // Demo method to showcase no-loss betting
  Future<bool> placeDemoBet({
    required String challengeId,
    required String teamName,
    required double stakeAmount,
    required double odds,
  }) async {
    if (stakeAmount <= 0) {
      _error = 'Stake amount must be greater than 0';
      notifyListeners();
      return false;
    }

    if (stakeAmount > _wallet.availableCredits) {
      _error =
          'Insufficient credits. Available: \$${_wallet.availableCredits.toStringAsFixed(2)}';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new demo bet
      final newBet = Bet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _wallet.userId,
        challengeId: challengeId,
        teamName: teamName,
        stakeAmount: stakeAmount,
        odds: odds,
        placedAt: DateTime.now(),
        status: BetStatus.pending,
        isDemo: true, // Mark as demo bet
      );

      // Add bet to list
      _bets.insert(0, newBet);

      // Update wallet - NO-LOSS LOGIC: stake credits remain constant
      _wallet = _wallet.copyWith(
        availableCredits: _wallet.availableCredits - stakeAmount,
        stakedCredits: _wallet.stakedCredits + stakeAmount,
        lastUpdated: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to place demo bet: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Auto-resolve demo bet after 5 minutes (for demo purposes)
  Future<void> autoResolveDemoBet(String betId, bool won) async {
    final betIndex = _bets.indexWhere((bet) => bet.id == betId);
    if (betIndex == -1) return;

    final bet = _bets[betIndex];
    final winAmount = won ? bet.stakeAmount * bet.odds : 0.0;

    // Update bet status
    _bets[betIndex] = Bet(
      id: bet.id,
      userId: bet.userId,
      challengeId: bet.challengeId,
      teamName: bet.teamName,
      stakeAmount: bet.stakeAmount,
      odds: bet.odds,
      placedAt: bet.placedAt,
      status: won ? BetStatus.won : BetStatus.lost,
      winAmount: winAmount,
      isDemo: true,
    );

    // NO-LOSS LOGIC: Always return stake + winnings (if any)
    _wallet = _wallet.copyWith(
      availableCredits: _wallet.availableCredits + bet.stakeAmount + winAmount,
      stakedCredits: _wallet.stakedCredits - bet.stakeAmount,
      totalCredits:
          _wallet.totalCredits + winAmount, // Only winnings increase total
      totalWinnings: _wallet.totalWinnings + winAmount,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();
  }
}
