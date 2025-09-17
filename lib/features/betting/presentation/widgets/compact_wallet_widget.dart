import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/betting_provider.dart';

class CompactWalletWidget extends StatelessWidget {
  const CompactWalletWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BettingProvider>(
      builder: (context, bettingProvider, child) {
        final wallet = bettingProvider.wallet;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                '\$${wallet.availableCredits.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
