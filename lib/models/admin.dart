
import 'user.dart';
import 'enums.dart';
import 'booking.dart';
import 'service_provider.dart';
import 'service_category.dart';

class Admin extends User {
  List<ServiceProvider> pendingVerifications;
  List<Booking> flaggedBookings;
  List<ServiceCategory> managedCategories;

  Admin({
    required super.userId,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.hashedPassword,
    required super.address,
  })  : pendingVerifications = [],
        flaggedBookings = [],
        managedCategories = [],
        super(userType: UserType.admin);

  
  void verifyServiceProvider(ServiceProvider provider) {
    provider.isVerified = true;
    pendingVerifications.remove(provider);
    print('Service Provider ${provider.name} has been verified');
  }

  void rejectServiceProvider(ServiceProvider provider, String reason) {
    pendingVerifications.remove(provider);

    print('Service Provider ${provider.name} rejected: $reason');
  }

  void suspendServiceProvider(ServiceProvider provider, String reason) {
    provider.isVerified = false;
  
    print('Service Provider ${provider.name} suspended: $reason');
  }

  
  void flagBooking(Booking booking, String reason) {
    if (!flaggedBookings.contains(booking)) {
      flaggedBookings.add(booking);
      print('Booking ${booking.bookingId} flagged: $reason');
    }
  }

  void resolveFlaggedBooking(Booking booking, String resolution) {
    flaggedBookings.remove(booking);
    print('Booking ${booking.bookingId} resolved: $resolution');
  }

  void cancelBooking(Booking booking, String reason) {
    booking.cancel();
    flaggedBookings.remove(booking);
    print('Admin cancelled booking ${booking.bookingId}: $reason');
  }


  void suspendUser(User user, String reason) {
    
    print('User ${user.name} (ID: ${user.userId}) suspended: $reason');
    
  }

  void activateUser(User user) {
    print('User ${user.name} (ID: ${user.userId}) activated');
  }

  
  void addServiceCategory(ServiceCategory category) {
    if (!managedCategories.any((c) => c.categoryId == category.categoryId)) {
      managedCategories.add(category);
      print('Service category "${category.name}" added');
    }
  }

  void updateServiceCategory(ServiceCategory category, String newName, String newDescription) {
    category.name = newName;
    category.description = newDescription;
    print('Service category updated to "$newName"');
  }

  void removeServiceCategory(ServiceCategory category) {
    managedCategories.remove(category);
    print('Service category "${category.name}" removed');
  }

 
  Map<String, dynamic> getPlatformStats(List<Booking> allBookings, List<User> allUsers) {
    final totalBookings = allBookings.length;
    final completedBookings = allBookings.where((b) => b.status == BookingStatus.completed).length;
    final totalCustomers = allUsers.where((u) => u.userType == UserType.customer).length;
    final totalProviders = allUsers.where((u) => u.userType == UserType.serviceProvider).length;
    final verifiedProviders = allUsers.where((u) => u is ServiceProvider && u.isVerified).length;

    return {
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'completionRate': totalBookings > 0 ? (completedBookings / totalBookings * 100).toStringAsFixed(1) : '0.0',
      'totalCustomers': totalCustomers,
      'totalServiceProviders': totalProviders,
      'verifiedProviders': verifiedProviders,
      'verificationRate': totalProviders > 0 ? (verifiedProviders / totalProviders * 100).toStringAsFixed(1) : '0.0',
    };
  }

  List<ServiceProvider> getPendingVerifications() {
    return List<ServiceProvider>.from(pendingVerifications);
  }

  List<Booking> getFlaggedBookings() {
    return List<Booking>.from(flaggedBookings);
  }


  void sendPlatformNotification(String title, String message, List<User> recipients) {
    for (final user in recipients) {
      
      print('Notification sent to ${user.name}: $title - $message');
    }
  }

  
  void performSystemCleanup() {

    final oldFlaggedBookings = flaggedBookings.where((booking) => 
      booking.creationDate.isBefore(DateTime.now().subtract(Duration(days: 30)))
    ).toList();
    
    flaggedBookings.removeWhere((booking) => oldFlaggedBookings.contains(booking));
    print('System cleanup completed. Removed ${oldFlaggedBookings.length} old flagged bookings');
  }
}