import 'package:equatable/equatable.dart';

class UserWallet extends Equatable {
  final String userId;
  final double totalCredits;
  final double availableCredits;
  final double stakedCredits;
  final double totalWinnings;
  final DateTime lastUpdated;

  const UserWallet({
    required this.userId,
    required this.totalCredits,
    required this.availableCredits,
    required this.stakedCredits,
    required this.totalWinnings,
    required this.lastUpdated,
  });

  UserWallet copyWith({
    String? userId,
    double? totalCredits,
    double? availableCredits,
    double? stakedCredits,
    double? totalWinnings,
    DateTime? lastUpdated,
  }) {
    return UserWallet(
      userId: userId ?? this.userId,
      totalCredits: totalCredits ?? this.totalCredits,
      availableCredits: availableCredits ?? this.availableCredits,
      stakedCredits: stakedCredits ?? this.stakedCredits,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object> get props => [
    userId,
    totalCredits,
    availableCredits,
    stakedCredits,
    totalWinnings,
    lastUpdated,
  ];
}
