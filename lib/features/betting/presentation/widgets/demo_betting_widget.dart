import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/betting_provider.dart';
import '../../../home/domain/entities/business_challenge.dart';
import '../../domain/entities/bet.dart';
import 'win_celebration_widget.dart';
import 'monetary_rewards_widget.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/domain/entities/notification.dart';

class DemoBettingWidget extends StatefulWidget {
  final BusinessChallenge challenge;

  const DemoBettingWidget({super.key, required this.challenge});

  @override
  State<DemoBettingWidget> createState() => _DemoBettingWidgetState();
}

class _DemoBettingWidgetState extends State<DemoBettingWidget> {
  final TextEditingController _stakeController = TextEditingController();
  double _selectedStake = 10.0;
  bool _isPlacingBet = false;
  bool _showNoLossExplanation = false;

  @override
  void initState() {
    super.initState();
    _stakeController.text = _selectedStake.toString();
  }

  @override
  void dispose() {
    _stakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BettingProvider>(
      builder: (context, bettingProvider, child) {
        final userBet = bettingProvider.getUserBetForChallenge(
          widget.challenge.id,
        );
        final wallet = bettingProvider.wallet;

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Demo Challenge Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.challenge.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.challenge.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // No-Loss Feature Explanation
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.security,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '🛡️ No-Loss Betting',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              _showNoLossExplanation
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                            onPressed: () {
                              setState(() {
                                _showNoLossExplanation =
                                    !_showNoLossExplanation;
                              });
                            },
                          ),
                        ],
                      ),
                      if (_showNoLossExplanation) ...[
                        const SizedBox(height: 8),
                        const Text(
                          '• Your stake is always returned (win or lose)\n'
                          '• You only gain additional rewards when you win\n'
                          '• Risk-free way to participate in challenges\n'
                          '• Perfect for testing the platform!',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Challenge Details
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Team',
                        widget.challenge.teamName,
                        widget.challenge.teamLogo,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        'Odds',
                        '${widget.challenge.odds}x',
                        '🎯',
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        'Time Left',
                        _formatTimeRemaining(widget.challenge.timeRemaining),
                        '⏰',
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Wallet Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available Credits: \$${wallet.availableCredits.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Betting Section
                if (userBet == null) ...[
                  // Place Bet Form
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Place Your Demo Bet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _stakeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stake Amount (\$)',
                          hintText: 'Enter amount to stake',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isPlacingBet
                              ? null
                              : () => _placeDemoBet(bettingProvider),
                          icon: _isPlacingBet
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.sports_esports),
                          label: Text(
                            _isPlacingBet ? 'Placing Bet...' : 'Place Demo Bet',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Bet Status
                  _buildBetStatus(userBet),
                ],

                // Error Message
                if (bettingProvider.error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bettingProvider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => bettingProvider.clearError(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value, String icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBetStatus(bet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bet.status == BetStatus.won
            ? Colors.green.withOpacity(0.1)
            : bet.status == BetStatus.lost
            ? Colors.red.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: bet.status == BetStatus.won
              ? Colors.green
              : bet.status == BetStatus.lost
              ? Colors.red
              : Colors.orange,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                bet.status == BetStatus.won
                    ? Icons.celebration
                    : bet.status == BetStatus.lost
                    ? Icons.cancel
                    : Icons.hourglass_empty,
                color: bet.status == BetStatus.won
                    ? Colors.green
                    : bet.status == BetStatus.lost
                    ? Colors.red
                    : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                bet.status == BetStatus.won
                    ? 'You Won!'
                    : bet.status == BetStatus.lost
                    ? 'You Lost'
                    : 'Bet Pending',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: bet.status == BetStatus.won
                      ? Colors.green
                      : bet.status == BetStatus.lost
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Stake: \$${bet.stakeAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14),
          ),
          if (bet.winAmount != null && bet.winAmount! > 0)
            Text(
              'Winnings: \$${bet.winAmount!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          if (bet.status == BetStatus.pending)
            Text(
              'Potential Win: \$${(bet.stakeAmount * bet.odds).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.orange),
            ),
        ],
      ),
    );
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Future<void> _placeDemoBet(BettingProvider bettingProvider) async {
    final stakeAmount = double.tryParse(_stakeController.text);
    if (stakeAmount == null || stakeAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid stake amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isPlacingBet = true;
    });

    final success = await bettingProvider.placeDemoBet(
      challengeId: widget.challenge.id,
      teamName: widget.challenge.teamName,
      stakeAmount: stakeAmount,
      odds: widget.challenge.odds,
    );

    setState(() {
      _isPlacingBet = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Demo bet placed successfully! Your stake is protected.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      _stakeController.clear();

      // Auto-resolve after 5 seconds for demo
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          bettingProvider.autoResolveDemoBet(
            bettingProvider.bets.first.id,
            true, // Demo always wins for showcase
          );

          // Show win animation automatically
          _showWinCelebration();

          // Add notification
          _addWinNotification();
        }
      });
    }
  }

  void _showWinCelebration() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WinCelebrationWidget(
        winnings: _selectedStake * widget.challenge.odds,
        challengeTitle: widget.challenge.title,
        teamName: widget.challenge.teamName,
        onAnimationComplete: () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            _showMonetaryReward();
          }
        },
      ),
    );
  }

  void _showMonetaryReward() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            MonetaryRewardsWidget(
              amount: _selectedStake * widget.challenge.odds,
              currency: 'USD',
              onComplete: () {
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addWinNotification() {
    final notificationProvider = context.read<NotificationProvider>();
    final winnings = _selectedStake * widget.challenge.odds;

    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '🎉 Demo Bet Won!',
      message:
          'Your bet on ${widget.challenge.teamName} won! You earned \$${winnings.toStringAsFixed(2)}',
      type: NotificationType.betWon,
      timestamp: DateTime.now(),
      isRead: false,
    );

    notificationProvider.addNotification(notification);
  }
}
