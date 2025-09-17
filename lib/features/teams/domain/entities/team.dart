import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String category;
  final String description;
  final int followersCount;
  final double winRate;
  final int totalChallenges;
  final int wonChallenges;
  final double totalEarnings;
  final DateTime foundedDate;
  final List<String> members;
  final String location;
  final String website;
  final List<PerformanceStat> performanceStats;
  final List<RecentActivity> recentActivities;

  const Team({
    required this.id,
    required this.name,
    required this.logo,
    required this.category,
    required this.description,
    required this.followersCount,
    required this.winRate,
    required this.totalChallenges,
    required this.wonChallenges,
    required this.totalEarnings,
    required this.foundedDate,
    required this.members,
    required this.location,
    required this.website,
    required this.performanceStats,
    required this.recentActivities,
  });

  @override
  List<Object> get props => [
    id,
    name,
    logo,
    category,
    description,
    followersCount,
    winRate,
    totalChallenges,
    wonChallenges,
    totalEarnings,
    foundedDate,
    members,
    location,
    website,
    performanceStats,
    recentActivities,
  ];
}

class PerformanceStat extends Equatable {
  final String metric;
  final double value;
  final String unit;
  final String period;
  final double change; // percentage change from previous period

  const PerformanceStat({
    required this.metric,
    required this.value,
    required this.unit,
    required this.period,
    required this.change,
  });

  @override
  List<Object> get props => [metric, value, unit, period, change];
}

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final String? challengeId;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.challengeId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    timestamp,
    type,
    challengeId,
  ];
}

enum ActivityType {
  challengeStarted,
  challengeCompleted,
  milestoneReached,
  newMember,
  announcement,
}
