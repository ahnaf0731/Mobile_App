import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart' as models;
import '../models/user.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  final List<models.Notification> _notifications = [];
  
  List<models.Notification> get notifications => _notifications;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification({
    required String title,
    required String message,
    required User recipient,
  }) async {
    final notification = models.Notification(
      notificationId: DateTime.now().millisecondsSinceEpoch,
      title: title,
      message: message,
      recipient: recipient,
    );
    
    _notifications.insert(0, notification);
    
    const androidDetails = AndroidNotificationDetails(
      'fix_it_now_channel',
      'FixItNow Notifications',
      channelDescription: 'Notifications for booking updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      notification.notificationId,
      title,
      message,
      details,
    );
  }

  Future<void> scheduleBookingReminder({
    required DateTime scheduledTime,
    required String serviceName,
    required User recipient,
  }) async {
    final reminderTime = scheduledTime.subtract(const Duration(hours: 2));
    
    if (reminderTime.isAfter(DateTime.now())) {
      await showNotification(
        title: 'Upcoming Service',
        message: 'Your $serviceName appointment is in 2 hours',
        recipient: recipient,
      );
    }
  }

  void clearNotifications() {
    _notifications.clear();
  }

  int get unreadCount => _notifications.length;
}
