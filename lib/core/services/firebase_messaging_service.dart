import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import 'firestore_service.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseConfig.messaging;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;
  static String? get fcmToken => _fcmToken;

  // Initialize Firebase Messaging
  static Future<void> initialize() async {
    // Initialize local notifications
    await _initializeLocalNotifications();

    // Request permission
    await _requestPermission();

    // Get FCM token
    await _getFCMToken();

    // Listen to token refresh
    _listenToTokenRefresh();

    // Handle foreground messages
    _handleForegroundMessages();

    // Handle notification taps
    _handleNotificationTaps();
  }

  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  // Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'sales_bets_channel',
      'Sales Bets Notifications',
      description: 'Notifications for Sales Bets app',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Request notification permission
  static Future<void> _requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Notification permission status: ${settings.authorizationStatus}');
    }
  }

  // Get FCM token
  static Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Save token to Firestore
      await _saveTokenToFirestore(_fcmToken);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }

  // Listen to token refresh
  static void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((String token) {
      _fcmToken = token;
      if (kDebugMode) {
        print('FCM Token refreshed: $token');
      }
      _saveTokenToFirestore(token);
    });
  }

  // Save FCM token to Firestore
  static Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null) return;

    try {
      final user = FirebaseConfig.auth.currentUser;
      if (user != null) {
        await FirestoreService.updateUser(user.uid, {
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving FCM token: $e');
      }
    }
  }

  // Handle foreground messages
  static void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
      }

      // Show local notification
      _showLocalNotification(message);
    });
  }

  // Handle notification taps
  static void _handleNotificationTaps() {
    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notification tapped: ${message.messageId}');
      }
      _handleNotificationTap(message);
    });

    // Handle notification taps when app is terminated
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          print('App opened from notification: ${message.messageId}');
        }
        _handleNotificationTap(message);
      }
    });
  }

  // Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'sales_bets_channel',
          'Sales Bets Notifications',
          channelDescription: 'Notifications for Sales Bets app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Sales Bets',
      message.notification?.body ?? 'You have a new notification',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  // Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    // Handle different notification types based on data
    final data = message.data;

    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'bet_result':
          _handleBetResultNotification(data);
          break;
        case 'challenge_update':
          _handleChallengeUpdateNotification(data);
          break;
        case 'team_activity':
          _handleTeamActivityNotification(data);
          break;
        case 'chat_message':
          _handleChatMessageNotification(data);
          break;
        default:
          if (kDebugMode) {
            print('Unknown notification type: ${data['type']}');
          }
      }
    }
  }

  // Handle bet result notification
  static void _handleBetResultNotification(Map<String, dynamic> data) {
    if (kDebugMode) {
      print('Bet result notification: ${data['betId']}');
    }
    // TODO: Navigate to bet details or show result
  }

  // Handle challenge update notification
  static void _handleChallengeUpdateNotification(Map<String, dynamic> data) {
    if (kDebugMode) {
      print('Challenge update notification: ${data['challengeId']}');
    }
    // TODO: Navigate to challenge details
  }

  // Handle team activity notification
  static void _handleTeamActivityNotification(Map<String, dynamic> data) {
    if (kDebugMode) {
      print('Team activity notification: ${data['teamId']}');
    }
    // TODO: Navigate to team profile
  }

  // Handle chat message notification
  static void _handleChatMessageNotification(Map<String, dynamic> data) {
    if (kDebugMode) {
      print('Chat message notification: ${data['streamId']}');
    }
    // TODO: Navigate to live stream chat
  }

  // Local notification tap handler
  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Local notification tapped: ${response.payload}');
    }
    // TODO: Handle local notification tap
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic: $e');
      }
    }
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic: $e');
      }
    }
  }

  // Send notification to specific user
  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // This would typically be done from a backend service
      // For now, we'll just log it
      if (kDebugMode) {
        print('Sending notification to user $userId: $title - $body');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
    }
  }

  // Get notification settings
  static Future<NotificationSettings> getNotificationSettings() async {
    return await _messaging.getNotificationSettings();
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final settings = await getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
