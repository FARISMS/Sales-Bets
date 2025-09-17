import 'package:equatable/equatable.dart';

class LiveStream extends Equatable {
  final String id;
  final String title;
  final String description;
  final String streamUrl;
  final String thumbnailUrl;
  final String teamId;
  final String teamName;
  final String teamLogo;
  final DateTime startTime;
  final DateTime? endTime;
  final StreamStatus status;
  final int viewerCount;
  final int chatMessageCount;
  final List<String> tags;
  final bool isLive;

  const LiveStream({
    required this.id,
    required this.title,
    required this.description,
    required this.streamUrl,
    required this.thumbnailUrl,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.viewerCount,
    required this.chatMessageCount,
    required this.tags,
    required this.isLive,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    streamUrl,
    thumbnailUrl,
    teamId,
    teamName,
    teamLogo,
    startTime,
    endTime,
    status,
    viewerCount,
    chatMessageCount,
    tags,
    isLive,
  ];

  LiveStream copyWith({
    String? id,
    String? title,
    String? description,
    String? streamUrl,
    String? thumbnailUrl,
    String? teamId,
    String? teamName,
    String? teamLogo,
    DateTime? startTime,
    DateTime? endTime,
    StreamStatus? status,
    int? viewerCount,
    int? chatMessageCount,
    List<String>? tags,
    bool? isLive,
  }) {
    return LiveStream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      streamUrl: streamUrl ?? this.streamUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamLogo: teamLogo ?? this.teamLogo,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      viewerCount: viewerCount ?? this.viewerCount,
      chatMessageCount: chatMessageCount ?? this.chatMessageCount,
      tags: tags ?? this.tags,
      isLive: isLive ?? this.isLive,
    );
  }
}

enum StreamStatus { scheduled, live, ended, cancelled }
