
import 'user.dart';

class Notification {
  int notificationId;
  String title;
  String message;
  DateTime timestamp;
  User recipient;

  Notification({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.recipient,
  }) : timestamp = DateTime.now();


  void send() {
    // Implementation for sending notification
    // This could be through Firebase, local notification
    print('Notification sent to ${recipient.name}: $title');
  }
}