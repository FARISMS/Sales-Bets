import 'package:equatable/equatable.dart';

class BusinessChallenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String teamName;
  final String teamLogo;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final ChallengeStatus status;
  final double odds;
  final int participantsCount;
  final String category;
  final bool isDemo;

  const BusinessChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.teamName,
    required this.teamLogo,
    required this.targetAmount,
    required this.currentAmount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.odds,
    required this.participantsCount,
    required this.category,
    this.isDemo = false,
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;

  Duration get timeRemaining => endDate.difference(DateTime.now());

  bool get isActive =>
      status == ChallengeStatus.active && DateTime.now().isBefore(endDate);

  @override
  List<Object> get props => [
    id,
    title,
    description,
    teamName,
    teamLogo,
    targetAmount,
    currentAmount,
    startDate,
    endDate,
    status,
    odds,
    participantsCount,
    category,
    isDemo,
  ];
}

enum ChallengeStatus { active, completed, cancelled, upcoming }
