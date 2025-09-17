import 'package:equatable/equatable.dart';

class Bet extends Equatable {
  final String id;
  final String userId;
  final String challengeId;
  final String teamName;
  final double stakeAmount;
  final double odds;
  final DateTime placedAt;
  final BetStatus status;
  final double? winAmount;
  final bool isDemo;

  const Bet({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.teamName,
    required this.stakeAmount,
    required this.odds,
    required this.placedAt,
    required this.status,
    this.winAmount,
    this.isDemo = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    challengeId,
    teamName,
    stakeAmount,
    odds,
    placedAt,
    status,
    winAmount,
    isDemo,
  ];
}

enum BetStatus { pending, won, lost, cancelled }
