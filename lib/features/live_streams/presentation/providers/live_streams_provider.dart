import 'package:flutter/foundation.dart';
import '../../domain/entities/live_stream.dart';
import '../../domain/entities/chat_message.dart';

class LiveStreamsProvider extends ChangeNotifier {
  List<LiveStream> _streams = [];
  List<ChatMessage> _chatMessages = [];
  bool _isLoading = false;
  String? _error;
  String? _currentStreamId;
  bool _isChatVisible = true;
  String _currentUserId = 'current_user_1'; // Mock current user ID

  List<LiveStream> get streams => _streams;
  List<ChatMessage> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentStreamId => _currentStreamId;
  bool get isChatVisible => _isChatVisible;

  // Get live streams only
  List<LiveStream> get liveStreams =>
      _streams.where((stream) => stream.isLive).toList();

  // Get scheduled streams
  List<LiveStream> get scheduledStreams => _streams
      .where((stream) => stream.status == StreamStatus.scheduled)
      .toList();

  // Get chat messages for current stream
  List<ChatMessage> get currentStreamChatMessages => _chatMessages
      .where((message) => message.streamId == _currentStreamId)
      .toList();

  Future<void> loadStreams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _streams = _generateMockStreams();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load streams: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStreams() async {
    await loadStreams();
  }

  void setCurrentStream(String streamId) {
    _currentStreamId = streamId;
    _loadChatMessages(streamId);
    notifyListeners();
  }

  void toggleChatVisibility() {
    _isChatVisible = !_isChatVisible;
    notifyListeners();
  }

  void sendChatMessage(String message) {
    if (message.trim().isEmpty || _currentStreamId == null) return;

    // Add message locally (Firebase integration can be added later)
    final chatMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      streamId: _currentStreamId!,
      userId: _currentUserId,
      username: 'You',
      userAvatar: '👤',
      message: message.trim(),
      timestamp: DateTime.now(),
      type: MessageType.normal,
      isFromCurrentUser: true,
    );

    _chatMessages.add(chatMessage);
    notifyListeners();

    // Simulate other users responding
    _simulateChatActivity();
  }

  void _loadChatMessages(String streamId) {
    _chatMessages = _generateMockChatMessages(streamId);
    notifyListeners();
  }

  void _simulateChatActivity() {
    // Simulate other users sending messages
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentStreamId != null) {
        final responses = [
          'Great stream! 🔥',
          'Amazing content!',
          'Keep it up! 💪',
          'This is awesome!',
          'Love the energy! ⚡',
          'Fantastic work!',
          'Incredible! 🚀',
          'So inspiring!',
        ];

        final randomResponse =
            responses[DateTime.now().millisecond % responses.length];
        final randomUser = _getRandomUser();

        final responseMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          streamId: _currentStreamId!,
          userId: randomUser['id']!,
          username: randomUser['name']!,
          userAvatar: randomUser['avatar']!,
          message: randomResponse,
          timestamp: DateTime.now(),
          type: MessageType.normal,
          isFromCurrentUser: false,
        );

        _chatMessages.add(responseMessage);
        notifyListeners();
      }
    });
  }

  Map<String, String> _getRandomUser() {
    final users = [
      {'id': 'user_1', 'name': 'Alex Chen', 'avatar': '👨‍💼'},
      {'id': 'user_2', 'name': 'Sarah Johnson', 'avatar': '👩‍💻'},
      {'id': 'user_3', 'name': 'Mike Rodriguez', 'avatar': '👨‍🚀'},
      {'id': 'user_4', 'name': 'Emma Thompson', 'avatar': '👩‍💼'},
      {'id': 'user_5', 'name': 'David Kim', 'avatar': '👨‍💻'},
    ];

    return users[DateTime.now().millisecond % users.length];
  }

  List<LiveStream> _generateMockStreams() {
    final now = DateTime.now();

    return [
      LiveStream(
        id: 'stream_1',
        title: 'Q4 Sales Strategy Deep Dive',
        description:
            'Join us as we break down our winning Q4 sales strategy and share insights from our recent success.',
        streamUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Demo video
        thumbnailUrl: 'https://picsum.photos/800/450?random=1',
        teamId: 'team_1',
        teamName: 'TechCorp Sales Team',
        teamLogo: '🏢',
        startTime: now.subtract(const Duration(minutes: 30)),
        status: StreamStatus.live,
        viewerCount: 1247,
        chatMessageCount: 89,
        tags: ['Sales', 'Strategy', 'Q4'],
        isLive: true,
      ),
      LiveStream(
        id: 'stream_2',
        title: 'Product Launch Live Event',
        description:
            'Witness the launch of our revolutionary new product with live demos and Q&A session.',
        streamUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', // Demo video
        thumbnailUrl: 'https://picsum.photos/800/450?random=2',
        teamId: 'team_2',
        teamName: 'StartupXYZ',
        teamLogo: '🚀',
        startTime: now.add(const Duration(hours: 2)),
        status: StreamStatus.scheduled,
        viewerCount: 0,
        chatMessageCount: 0,
        tags: ['Product', 'Launch', 'Innovation'],
        isLive: false,
      ),
      LiveStream(
        id: 'stream_3',
        title: 'E-commerce Growth Hacking',
        description:
            'Learn advanced e-commerce growth strategies from our expert team.',
        streamUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', // Demo video
        thumbnailUrl: 'https://picsum.photos/800/450?random=3',
        teamId: 'team_3',
        teamName: 'ShopMax',
        teamLogo: '🛒',
        startTime: now.subtract(const Duration(hours: 1)),
        status: StreamStatus.live,
        viewerCount: 892,
        chatMessageCount: 156,
        tags: ['E-commerce', 'Growth', 'Marketing'],
        isLive: true,
      ),
      LiveStream(
        id: 'stream_4',
        title: 'FinTech Innovation Panel',
        description:
            'Panel discussion on the future of financial technology and digital payments.',
        streamUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', // Demo video
        thumbnailUrl: 'https://picsum.photos/800/450?random=4',
        teamId: 'team_4',
        teamName: 'PayFlow',
        teamLogo: '💳',
        startTime: now.add(const Duration(hours: 4)),
        status: StreamStatus.scheduled,
        viewerCount: 0,
        chatMessageCount: 0,
        tags: ['FinTech', 'Innovation', 'Payments'],
        isLive: false,
      ),
    ];
  }

  List<ChatMessage> _generateMockChatMessages(String streamId) {
    final now = DateTime.now();

    return [
      ChatMessage(
        id: 'msg_1',
        streamId: streamId,
        userId: 'user_1',
        username: 'Alex Chen',
        userAvatar: '👨‍💼',
        message: 'Great to see everyone here! 🎉',
        timestamp: now.subtract(const Duration(minutes: 25)),
        type: MessageType.normal,
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: 'msg_2',
        streamId: streamId,
        userId: 'user_2',
        username: 'Sarah Johnson',
        userAvatar: '👩‍💻',
        message: 'Excited for this session!',
        timestamp: now.subtract(const Duration(minutes: 23)),
        type: MessageType.normal,
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: 'msg_3',
        streamId: streamId,
        userId: 'system',
        username: 'System',
        userAvatar: '🤖',
        message: 'Welcome to the live stream! Please keep chat respectful.',
        timestamp: now.subtract(const Duration(minutes: 20)),
        type: MessageType.system,
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: 'msg_4',
        streamId: streamId,
        userId: 'user_3',
        username: 'Mike Rodriguez',
        userAvatar: '👨‍🚀',
        message: 'Love the energy in here! 🔥',
        timestamp: now.subtract(const Duration(minutes: 18)),
        type: MessageType.normal,
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: 'msg_5',
        streamId: streamId,
        userId: 'user_4',
        username: 'Emma Thompson',
        userAvatar: '👩‍💼',
        message: 'This is so informative!',
        timestamp: now.subtract(const Duration(minutes: 15)),
        type: MessageType.normal,
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: 'msg_6',
        streamId: streamId,
        userId: 'user_5',
        username: 'David Kim',
        userAvatar: '👨‍💻',
        message: 'Amazing insights! 💡',
        timestamp: now.subtract(const Duration(minutes: 12)),
        type: MessageType.normal,
        isFromCurrentUser: false,
      ),
    ];
  }
}
