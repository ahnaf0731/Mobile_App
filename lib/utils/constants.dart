class AppConstants {
  // App Info
  static const String appName = 'FixItNow';
  static const String appTagline = 'Your Home Maintenance Solution';

  // Time Slots
  static const List<String> timeSlots = [
    '08:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 02:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
    '06:00 PM - 08:00 PM',
  ];

  // Service Categories
  static const Map<String, String> serviceCategories = {
    'Electrician': '⚡',
    'Plumber': '🔧',
    'Carpenter': '🔨',
    'Cleaner': '🧹',
    'Painter': '🎨',
    'AC Repair': '❄️',
  };

  // Booking Status Colors
  static const Map<String, String> bookingStatusText = {
    'pending': 'Pending',
    'confirmed': 'Confirmed',
    'inProgress': 'In Progress',
    'completed': 'Completed',
    'canceled': 'Canceled',
    'rejected': 'Rejected',
  };

  // Validation
  static const int minPasswordLength = 6;
  static const int minPhoneLength = 10;
}
