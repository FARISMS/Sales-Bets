import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/firebase_config.dart';
import '../../features/betting/domain/entities/bet.dart';
import '../../features/live_streams/domain/entities/chat_message.dart';

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();

  final FirebaseFirestore _firestore = FirebaseConfig.firestore;
  final FirebaseAuth _auth = FirebaseConfig.auth;

  // Stream controllers for real-time updates
  final Map<String, StreamSubscription> _subscriptions = {};

  // Real-time betting results
  Stream<List<Bet>> watchUserBets(String userId) {
    return _firestore
        .collection(FirebaseConfig.betsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Bet(
              id: doc.id,
              userId: data['userId'] ?? '',
              challengeId: data['challengeId'] ?? '',
              teamName: data['teamName'] ?? '',
              stakeAmount: (data['stakeAmount'] ?? 0).toDouble(),
              odds: (data['odds'] ?? 1.0).toDouble(),
              placedAt:
                  (data['placedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              status: BetStatus.values.firstWhere(
                (status) => status.name == data['status'],
                orElse: () => BetStatus.pending,
              ),
              winAmount: (data['winAmount'] ?? 0).toDouble(),
            );
          }).toList();
        });
  }

  // Real-time chat messages for a stream
  Stream<List<ChatMessage>> watchStreamChat(String streamId) {
    return _firestore
        .collection(FirebaseConfig.chatMessagesCollection)
        .where('streamId', isEqualTo: streamId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage(
              id: doc.id,
              streamId: data['streamId'] ?? '',
              userId: data['userId'] ?? '',
              username: data['username'] ?? '',
              userAvatar: data['userAvatar'] ?? '👤',
              message: data['message'] ?? '',
              timestamp:
                  (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
              type: MessageType.values.firstWhere(
                (type) => type.name == data['type'],
                orElse: () => MessageType.normal,
              ),
              isFromCurrentUser: data['userId'] == _auth.currentUser?.uid,
            );
          }).toList();
        });
  }

  // Send chat message
  Future<void> sendChatMessage({
    required String streamId,
    required String message,
    required String username,
    required String userAvatar,
    MessageType type = MessageType.normal,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection(FirebaseConfig.chatMessagesCollection).add({
      'streamId': streamId,
      'userId': user.uid,
      'username': username,
      'userAvatar': userAvatar,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'type': type.name,
    });
  }

  // Update bet status (for real-time betting results)
  Future<void> updateBetStatus(String betId, BetStatus status) async {
    await _firestore
        .collection(FirebaseConfig.betsCollection)
        .doc(betId)
        .update({
          'status': status.name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  // Simulate bet result (for demo purposes)
  Future<void> simulateBetResult(String betId, bool isWin) async {
    final status = isWin ? BetStatus.won : BetStatus.lost;
    await updateBetStatus(betId, status);
  }

  // Watch for bet result updates
  Stream<Bet?> watchBetResult(String betId) {
    return _firestore
        .collection(FirebaseConfig.betsCollection)
        .doc(betId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;

          final data = doc.data()!;
          return Bet(
            id: doc.id,
            userId: data['userId'] ?? '',
            challengeId: data['challengeId'] ?? '',
            teamName: data['teamName'] ?? '',
            stakeAmount: (data['stakeAmount'] ?? 0).toDouble(),
            odds: (data['odds'] ?? 1.0).toDouble(),
            placedAt:
                (data['placedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            status: BetStatus.values.firstWhere(
              (status) => status.name == data['status'],
              orElse: () => BetStatus.pending,
            ),
            winAmount: (data['winAmount'] ?? 0).toDouble(),
          );
        });
  }

  // Watch for challenge updates
  Stream<Map<String, dynamic>> watchChallengeUpdates(String challengeId) {
    return _firestore
        .collection(FirebaseConfig.challengesCollection)
        .doc(challengeId)
        .snapshots()
        .map((doc) => doc.data() ?? {});
  }

  // Clean up subscriptions
  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
