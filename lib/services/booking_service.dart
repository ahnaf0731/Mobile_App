import '../models/booking.dart';
import '../models/service_category.dart';
import '../models/time_slot.dart';

class BookingService {
  final List<Booking> _bookings = [];
  final List<ServiceCategory> _categories = [];

  List<Booking> get bookings => _bookings;
  List<ServiceCategory> get categories => _categories;

  BookingService() {
    _initializeCategories();
  }

  void _initializeCategories() {
    _categories.addAll([
      ServiceCategory(
        categoryId: 1,
        name: 'Electrician',
        description: 'Electrical repairs and installations',
        iconUrl: '⚡',
      ),
      ServiceCategory(
        categoryId: 2,
        name: 'Plumber',
        description: 'Plumbing services and repairs',
        iconUrl: '🔧',
      ),
      ServiceCategory(
        categoryId: 3,
        name: 'Carpenter',
        description: 'Woodwork and furniture repairs',
        iconUrl: '🔨',
      ),
      ServiceCategory(
        categoryId: 4,
        name: 'Cleaner',
        description: 'House cleaning services',
        iconUrl: '🧹',
      ),
      ServiceCategory(
        categoryId: 5,
        name: 'Painter',
        description: 'Painting and decoration',
        iconUrl: '🎨',
      ),
      ServiceCategory(
        categoryId: 6,
        name: 'AC Repair',
        description: 'AC installation and repair',
        iconUrl: '❄️',
      ),
    ]);
  }

  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final slots = <TimeSlot>[];
    final baseDate = DateTime(date.year, date.month, date.day);
    
    for (int i = 0; i < 6; i++) {
      final startHour = 8 + (i * 2);
      slots.add(TimeSlot(
        slotId: i + 1,
        start: baseDate.add(Duration(hours: startHour)),
        endTime: baseDate.add(Duration(hours: startHour + 2)),
        isAvailable: true,
      ));
    }
    
    return slots;
  }

  Future<bool> createBooking({
    required DateTime scheduledDate,
    required String problemDescription,
    required TimeSlot timeSlot,
    required int categoryId,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock booking creation
    return true;
  }

  Future<List<Booking>> getUserBookings() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings;
  }

  Future<bool> cancelBooking(int bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final booking = _bookings.firstWhere((b) => b.bookingId == bookingId);
    booking.cancel();
    return true;
  }

  Future<bool> rescheduleBooking(int bookingId, DateTime newDate, TimeSlot newSlot) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final booking = _bookings.firstWhere((b) => b.bookingId == bookingId);
    booking.reschedule(newSlot);
    return true;
  }
}
