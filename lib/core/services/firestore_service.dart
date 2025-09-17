import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  // Generic CRUD operations

  // Create document
  static Future<String> createDocument({
    required String collection,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      final docRef = documentId != null
          ? _firestore.collection(collection).doc(documentId)
          : _firestore.collection(collection).doc();

      await docRef.set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  // Read document
  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  // Update document
  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Delete document
  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Get collection stream
  static Stream<List<Map<String, dynamic>>> getCollectionStream({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>>)?
    queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    if (queryBuilder != null) {
      final builtQuery = queryBuilder(query);
      if (builtQuery != null) {
        query = builtQuery;
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    });
  }

  // Get document stream
  static Stream<Map<String, dynamic>?> getDocumentStream({
    required String collection,
    required String documentId,
  }) {
    return _firestore.collection(collection).doc(documentId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return {'id': snapshot.id, ...snapshot.data()!};
      }
      return null;
    });
  }

  // Batch operations
  static Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final docRef = _firestore
            .collection(operation.collection)
            .doc(operation.documentId);

        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(docRef, {
              ...?operation.data,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            break;
          case BatchOperationType.update:
            batch.update(docRef, {
              ...?operation.data,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            break;
          case BatchOperationType.delete:
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to execute batch operation: $e');
    }
  }

  // Transaction operations
  static Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    try {
      return await _firestore.runTransaction(updateFunction);
    } catch (e) {
      throw Exception('Transaction failed: $e');
    }
  }

  // Specific methods for app collections

  // Users
  static Future<String> createUser(Map<String, dynamic> userData) async {
    return createDocument(
      collection: FirebaseConfig.usersCollection,
      data: userData,
    );
  }

  static Stream<Map<String, dynamic>?> getUserStream(String userId) {
    return getDocumentStream(
      collection: FirebaseConfig.usersCollection,
      documentId: userId,
    );
  }

  static Future<void> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return updateDocument(
      collection: FirebaseConfig.usersCollection,
      documentId: userId,
      data: data,
    );
  }

  // Bets
  static Future<String> createBet(Map<String, dynamic> betData) async {
    return createDocument(
      collection: FirebaseConfig.betsCollection,
      data: betData,
    );
  }

  static Stream<List<Map<String, dynamic>>> getUserBetsStream(String userId) {
    return getCollectionStream(
      collection: FirebaseConfig.betsCollection,
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      orderBy: 'createdAt',
      descending: true,
    );
  }

  static Future<void> updateBet(String betId, Map<String, dynamic> data) async {
    return updateDocument(
      collection: FirebaseConfig.betsCollection,
      documentId: betId,
      data: data,
    );
  }

  // Challenges
  static Stream<List<Map<String, dynamic>>> getChallengesStream() {
    return getCollectionStream(
      collection: FirebaseConfig.challengesCollection,
      queryBuilder: (query) => query.where('isActive', isEqualTo: true),
      orderBy: 'createdAt',
      descending: true,
    );
  }

  // Teams
  static Stream<List<Map<String, dynamic>>> getTeamsStream() {
    return getCollectionStream(
      collection: FirebaseConfig.teamsCollection,
      orderBy: 'followersCount',
      descending: true,
    );
  }

  // Chat Messages
  static Future<String> createChatMessage(
    Map<String, dynamic> messageData,
  ) async {
    return createDocument(
      collection: FirebaseConfig.chatMessagesCollection,
      data: messageData,
    );
  }

  static Stream<List<Map<String, dynamic>>> getChatMessagesStream(
    String streamId,
  ) {
    return getCollectionStream(
      collection: FirebaseConfig.chatMessagesCollection,
      queryBuilder: (query) => query.where('streamId', isEqualTo: streamId),
      orderBy: 'timestamp',
      descending: false,
    );
  }

  // Live Streams
  static Stream<List<Map<String, dynamic>>> getLiveStreamsStream() {
    return getCollectionStream(
      collection: FirebaseConfig.streamsCollection,
      queryBuilder: (query) => query.where('isLive', isEqualTo: true),
      orderBy: 'startTime',
      descending: true,
    );
  }
}

// Batch operation model
class BatchOperation {
  final String collection;
  final String documentId;
  final BatchOperationType type;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.collection,
    required this.documentId,
    required this.type,
    this.data,
  });
}

enum BatchOperationType { set, update, delete }
