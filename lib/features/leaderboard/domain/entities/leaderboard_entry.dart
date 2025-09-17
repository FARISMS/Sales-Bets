import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String avatar;
  final double totalEarnings;
  final int totalBets;
  final double winRate;
  final int rank;
  final String badge;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.totalEarnings,
    required this.totalBets,
    required this.winRate,
    required this.rank,
    required this.badge,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    avatar,
    totalEarnings,
    totalBets,
    winRate,
    rank,
    badge,
    isCurrentUser,
  ];

  LeaderboardEntry copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatar,
    double? totalEarnings,
    int? totalBets,
    double? winRate,
    int? rank,
    String? badge,
    bool? isCurrentUser,
  }) {
    return LeaderboardEntry(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalBets: totalBets ?? this.totalBets,
      winRate: winRate ?? this.winRate,
      rank: rank ?? this.rank,
      badge: badge ?? this.badge,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
