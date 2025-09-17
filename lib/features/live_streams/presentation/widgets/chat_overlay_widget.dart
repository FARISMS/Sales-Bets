import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/live_streams_provider.dart';
import '../../domain/entities/chat_message.dart';

class ChatOverlayWidget extends StatefulWidget {
  final String streamId;

  const ChatOverlayWidget({super.key, required this.streamId});

  @override
  State<ChatOverlayWidget> createState() => _ChatOverlayWidgetState();
}

class _ChatOverlayWidgetState extends State<ChatOverlayWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveStreamsProvider>(
      builder: (context, provider, child) {
        final messages = provider.currentStreamChatMessages;

        // Auto-scroll to bottom when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Chat header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'Live Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${messages.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Messages list
              Expanded(
                child: messages.isEmpty
                    ? const Center(
                        child: Text(
                          'No messages yet\nBe the first to chat!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _buildChatMessage(message);
                        },
                      ),
              ),

              // Message input
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        maxLines: 1,
                        onSubmitted: (value) {
                          _sendMessage(provider);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () => _sendMessage(provider),
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 16,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    Color messageColor;
    Color backgroundColor;
    IconData? messageIcon;

    switch (message.type) {
      case MessageType.system:
        messageColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.2);
        messageIcon = Icons.info;
        break;
      case MessageType.announcement:
        messageColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.2);
        messageIcon = Icons.campaign;
        break;
      case MessageType.donation:
        messageColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.2);
        messageIcon = Icons.attach_money;
        break;
      case MessageType.follow:
        messageColor = Colors.purple;
        backgroundColor = Colors.purple.withOpacity(0.2);
        messageIcon = Icons.person_add;
        break;
      case MessageType.normal:
        messageColor = Colors.white;
        backgroundColor = Colors.transparent;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: message.isFromCurrentUser
            ? Border.all(color: Colors.blue.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message header
          Row(
            children: [
              Text(message.userAvatar, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                message.username,
                style: TextStyle(
                  color: messageColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (messageIcon != null) ...[
                const SizedBox(width: 4),
                Icon(messageIcon, size: 10, color: messageColor),
              ],
              const Spacer(),
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Message content
          Text(
            message.message,
            style: TextStyle(color: messageColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _sendMessage(LiveStreamsProvider provider) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      provider.sendChatMessage(message);
      _messageController.clear();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
