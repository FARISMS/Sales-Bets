import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

class FirebaseConfig {
  static FirebaseFirestore? _firestore;
  static FirebaseAuth? _auth;
  static FirebaseMessaging? _messaging;

  static FirebaseFirestore get firestore {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }

  static FirebaseAuth get auth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

  static FirebaseMessaging get messaging {
    _messaging ??= FirebaseMessaging.instance;
    return _messaging!;
  }

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Configure Firestore settings
      _firestore = FirebaseFirestore.instance;
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Initialize Firebase Auth
      _auth = FirebaseAuth.instance;

      // Initialize Firebase Messaging
      _messaging = FirebaseMessaging.instance;

      // Configure Firebase Messaging
      await _configureFirebaseMessaging();

      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
      print('Running in development mode without Firebase');
      // Continue without Firebase for development
    }
  }

  static Future<void> _configureFirebaseMessaging() async {
    // Request permission for notifications
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission for notifications');
    } else {
      print('User declined or has not accepted permission for notifications');
    }

    // Get FCM token
    String? token = await _messaging!.getToken();
    print('FCM Token: $token');

    // Listen to token refresh
    _messaging!.onTokenRefresh.listen((String token) {
      print('FCM Token refreshed: $token');
      // TODO: Send token to server
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String betsCollection = 'bets';
  static const String challengesCollection = 'challenges';
  static const String teamsCollection = 'teams';
  static const String streamsCollection = 'streams';
  static const String chatMessagesCollection = 'chat_messages';
  static const String notificationsCollection = 'notifications';
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
}
