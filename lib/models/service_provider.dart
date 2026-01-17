import 'user.dart';
import 'admin.dart';
import 'enums.dart';
import 'booking.dart';
import 'review.dart';
import 'time_slot.dart';
import 'service_category.dart';

class ServiceProvider extends User {
  ServiceCategory serviceCategory;

  String bio;
  double averageRating;
  bool isVerified;
  
  List<Booking> assignedBookings;
  List<Review> reviews;

DateTime verificationDate; 
  String? verificationNotes; 
  ServiceProvider({
    required super.userId,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.hashedPassword,
    required super.address,
    required this.serviceCategory,
  
    required this.bio,
    this.averageRating = 0.0,
    this.isVerified = false,

  })  : assignedBookings = [],
        reviews = [],
        verificationDate = DateTime.now(),
        super(userType: UserType.serviceProvider);



  void verifyServiceProvider(Admin admin, String? notes) {
    isVerified = true;
    verificationDate = DateTime.now();
    verificationNotes = notes;
    
    print('${admin.name} verified ${name} on $verificationDate');
  }



  void requestVerification(Admin admin) {
    if (!admin.pendingVerifications.contains(this)) {
      admin.pendingVerifications.add(this);
      print('Verification requested for $name');
    }

  }
  void acceptBooking(Booking booking) {
    if (booking.status != BookingStatus.pending) {
      throw Exception('Can only accept pending bookings');
    }
    
    booking.status = BookingStatus.confirmed;
    booking.serviceProvider = this; 
    assignedBookings.add(booking);
  }

  void rejectBooking(Booking booking) {
    if (booking.status != BookingStatus.pending) {
      throw Exception('Can only reject pending bookings');
    }
    
    booking.status = BookingStatus.rejected;
    booking.timeSlot.isAvailable = true; 
  }

  void completeBooking(Booking booking) {
    if (booking.status != BookingStatus.inProgress && 
        booking.status != BookingStatus.confirmed) {
      throw Exception('Can only complete confirmed or in-progress bookings');
    }
    
    if (booking.serviceProvider?.userId != userId) {
      throw Exception('Cannot complete booking assigned to another provider');
    }
    
    booking.status = BookingStatus.completed;
  }

  void updateAverageRating() {
    if (reviews.isEmpty) {
      averageRating = 0.0;
      return;
    }
    

    double total = reviews.map((r) => r.rating.toDouble()).reduce((a, b) => a + b);
    averageRating = double.parse((total / reviews.length).toStringAsFixed(1));
  }


  List<Booking> getActiveBookings() {
    return assignedBookings.where((booking) => 
      booking.status == BookingStatus.confirmed || 
      booking.status == BookingStatus.inProgress
    ).toList();
  }

  
  int getCompletedBookingsCount() {
    return assignedBookings.where((booking) => 
      booking.status == BookingStatus.completed
    ).length;
  }

 
  bool isAvailableForSlot(TimeSlot slot) {
    return !assignedBookings.any((booking) =>
      booking.timeSlot.slotId == slot.slotId &&
      (booking.status == BookingStatus.confirmed || 
       booking.status == BookingStatus.inProgress)
    );
  }
}