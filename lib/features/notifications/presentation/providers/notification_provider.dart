import 'package:flutter/foundation.dart';
import '../../domain/entities/notification.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;

  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }

  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }
  
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate loading notifications
      await Future.delayed(const Duration(seconds: 1));
      
      // Add demo notifications if none exist
      if (_notifications.isEmpty) {
        addDemoNotifications();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Demo notifications for testing
  void addDemoNotifications() {
    final now = DateTime.now();

    _notifications = [
      AppNotification(
        id: '1',
        title: '🎉 Bet Won!',
        message: 'Your demo bet on Demo Team Alpha won! You earned \$20.00',
        type: NotificationType.betWon,
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      AppNotification(
        id: '2',
        title: '📊 Challenge Update',
        message: 'Q4 Sales Target Challenge is 75% complete',
        type: NotificationType.challengeUpdate,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      AppNotification(
        id: '3',
        title: '👥 Team Update',
        message: 'TechCorp Sales Team added new performance metrics',
        type: NotificationType.teamUpdate,
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: '🎯 New Challenge',
        message: 'Product Launch Success challenge is now live!',
        type: NotificationType.challengeUpdate,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '5',
        title: '💰 Welcome Bonus',
        message: 'Welcome to Sales Bets! You received 1000 free credits',
        type: NotificationType.general,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];

    notifyListeners();
  }

  // Simulate real-time notifications
  void simulateNotification() {
    final now = DateTime.now();
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '🔔 New Update',
      message: 'A new challenge is available for betting',
      type: NotificationType.challengeUpdate,
      timestamp: now,
      isRead: false,
    );

    addNotification(notification);
  }
}
