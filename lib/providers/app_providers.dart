import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';
import '../services/notification_service.dart';

// Service Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final bookingServiceProvider = Provider<BookingService>((ref) => BookingService());
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

// State Providers
final currentUserProvider = StateProvider((ref) {
  return ref.watch(authServiceProvider).currentUser;
});

final bookingsProvider = FutureProvider((ref) async {
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getUserBookings();
});

final categoriesProvider = Provider((ref) {
  return ref.watch(bookingServiceProvider).categories;
});

final notificationsProvider = StateProvider((ref) {
  return ref.watch(notificationServiceProvider).notifications;
});
