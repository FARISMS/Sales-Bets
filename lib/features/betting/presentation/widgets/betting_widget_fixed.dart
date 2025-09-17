import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/betting_provider.dart';
import '../../../home/domain/entities/business_challenge.dart';
import '../../domain/entities/bet.dart';

class BettingWidget extends StatefulWidget {
  final BusinessChallenge challenge;

  const BettingWidget({super.key, required this.challenge});

  @override
  State<BettingWidget> createState() => _BettingWidgetState();
}

class _BettingWidgetState extends State<BettingWidget> {
  final TextEditingController _stakeController = TextEditingController();
  double _selectedStake = 10.0;
  bool _isPlacingBet = false;

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
        final wallet = bettingProvider.wallet;
        final existingBet = bettingProvider.getUserBetForChallenge(
          widget.challenge.id,
        );

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        widget.challenge.teamLogo,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.challenge.teamName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.challenge.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Wallet Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Wallet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Credits',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '\$${wallet.availableCredits.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Credits',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '\$${wallet.totalCredits.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Existing Bet Check
                  if (existingBet != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: existingBet.status == BetStatus.won
                            ? Colors.green.withOpacity(0.1)
                            : existingBet.status == BetStatus.lost
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                existingBet.status == BetStatus.won
                                    ? Icons.check_circle
                                    : existingBet.status == BetStatus.lost
                                    ? Icons.cancel
                                    : Icons.schedule,
                                color: existingBet.status == BetStatus.won
                                    ? Colors.green
                                    : existingBet.status == BetStatus.lost
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                existingBet.status == BetStatus.won
                                    ? 'You Won!'
                                    : existingBet.status == BetStatus.lost
                                    ? 'Challenge Lost'
                                    : 'Bet Placed',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: existingBet.status == BetStatus.won
                                      ? Colors.green
                                      : existingBet.status == BetStatus.lost
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stake: \$${existingBet.stakeAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (existingBet.winAmount != null &&
                              existingBet.winAmount! > 0)
                            Text(
                              'Winnings: \$${existingBet.winAmount!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Betting Form (only show if no existing bet or bet is resolved)
                  if (existingBet == null ||
                      existingBet.status != BetStatus.pending) ...[
                    // Odds Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Odds',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.challenge.odds}x',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stake Amount
                    const Text(
                      'Stake Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quick Stake Buttons
                    Row(
                      children: [10, 25, 50, 100].map((amount) {
                        final isSelected = _selectedStake == amount.toDouble();
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedStake = amount.toDouble();
                                  _stakeController.text = _selectedStake
                                      .toString();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[200],
                                foregroundColor: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text('\$$amount'),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // Custom Stake Input
                    TextField(
                      controller: _stakeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Custom Amount',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value);
                        if (amount != null) {
                          setState(() {
                            _selectedStake = amount;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Potential Winnings
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Potential Winnings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${(_selectedStake * widget.challenge.odds).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // No-Loss Notice
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.security,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'No-Loss Guarantee: Your stake is always returned!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Place Bet Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isPlacingBet ||
                                _selectedStake > wallet.availableCredits
                            ? null
                            : () async {
                                setState(() {
                                  _isPlacingBet = true;
                                });

                                final success = await bettingProvider.placeBet(
                                  challengeId: widget.challenge.id,
                                  teamName: widget.challenge.teamName,
                                  stakeAmount: _selectedStake,
                                  odds: widget.challenge.odds,
                                );

                                setState(() {
                                  _isPlacingBet = false;
                                });

                                if (success) {
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Bet placed successfully! Stake: \$${_selectedStake.toStringAsFixed(2)}',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          bettingProvider.error ??
                                              'Failed to place bet',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isPlacingBet
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                _selectedStake > wallet.availableCredits
                                    ? 'Insufficient Credits'
                                    : 'Place Bet (\$${_selectedStake.toStringAsFixed(2)})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
