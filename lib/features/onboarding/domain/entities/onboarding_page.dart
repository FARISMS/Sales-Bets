import 'package:equatable/equatable.dart';

class OnboardingPage extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final String? iconData;
  final List<String> features;
  final OnboardingPageType type;

  const OnboardingPage({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.iconData,
    required this.features,
    required this.type,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imagePath,
    iconData,
    features,
    type,
  ];
}

enum OnboardingPageType {
  welcome,
  concept,
  betting,
  rewards,
  teams,
  streaming,
  complete,
}
