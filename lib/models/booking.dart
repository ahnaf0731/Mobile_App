import 'enums.dart';
import 'time_slot.dart';
import 'admin.dart';
import 'customer.dart';
import 'service_provider.dart';

class Booking {
  int bookingId;
  DateTime creationDate;
  DateTime scheduledDate;
  DateTime timesNot; 
  String problemDescription;
  BookingStatus status;
  TimeSlot timeSlot;
  Customer customer;
  ServiceProvider? serviceProvider;
  bool isFlagged;
  String? flagReason;
  DateTime? flaggedAt;

  Booking({
    required this.bookingId,
    required this.creationDate,
    required this.scheduledDate,
    required this.timesNot,
    required this.problemDescription,
    required this.timeSlot,
    required this.customer,
    this.serviceProvider,
    this.status = BookingStatus.pending,
  })  : isFlagged = false,
        flaggedAt = null {
    if (!timeSlot.isAvailable) {
      throw Exception('Time slot is not available for booking');
    }

    if (scheduledDate.isBefore(DateTime.now())) {
      throw Exception('Scheduled date cannot be in the past');
    }

    timeSlot.isAvailable = false;
    customer.bookings.add(this);
  }


  void flagBooking(String reason) {
    isFlagged = true;
    flagReason = reason;
    flaggedAt = DateTime.now();
  }

  void resolveFlag() {
    isFlagged = false;
    flagReason = null;
    flaggedAt = null;
  }

 
  void cancel({Admin? admin, String? adminReason}) {
    if (status == BookingStatus.completed) {
      throw Exception('Cannot cancel a completed booking');
    }

    status = BookingStatus.canceled;
    timeSlot.isAvailable = true;

    if (admin != null) {
      print('Booking cancelled by admin ${admin.name}: $adminReason');
      admin.flaggedBookings.remove(this);
    }
  }

 
  void reschedule(TimeSlot newTimeSlot) {
    if (!newTimeSlot.isAvailable) {
      throw Exception('New time slot is not available');
    }

    timeSlot.isAvailable = true;
    timeSlot = newTimeSlot;
    timeSlot.isAvailable = false;

    scheduledDate = newTimeSlot.start;
    timesNot = newTimeSlot.endTime;

    if (status == BookingStatus.confirmed ||
        status == BookingStatus.inProgress) {
      status = BookingStatus.pending;
    }
  }


  bool isActive() {
    return status == BookingStatus.pending ||
        status == BookingStatus.confirmed ||
        status == BookingStatus.inProgress;
  }

  Duration get duration => timesNot.difference(scheduledDate);
}
