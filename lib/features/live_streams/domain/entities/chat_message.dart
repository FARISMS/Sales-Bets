import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String streamId;
  final String userId;
  final String username;
  final String userAvatar;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final bool isFromCurrentUser;

  const ChatMessage({
    required this.id,
    required this.streamId,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isFromCurrentUser = false,
  });

  @override
  List<Object?> get props => [
    id,
    streamId,
    userId,
    username,
    userAvatar,
    message,
    timestamp,
    type,
    isFromCurrentUser,
  ];

  ChatMessage copyWith({
    String? id,
    String? streamId,
    String? userId,
    String? username,
    String? userAvatar,
    String? message,
    DateTime? timestamp,
    MessageType? type,
    bool? isFromCurrentUser,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      streamId: streamId ?? this.streamId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isFromCurrentUser: isFromCurrentUser ?? this.isFromCurrentUser,
    );
  }
}

enum MessageType { normal, system, announcement, donation, follow }
