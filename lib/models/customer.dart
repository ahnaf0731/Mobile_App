

import 'user.dart';
import 'admin.dart';
import 'enums.dart';
import 'booking.dart';
import 'review.dart';
import 'service_provider.dart';

class Customer extends User {
  List<Booking> bookings;
  List<Review> reviews;

  Customer({
    required super.userId,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.hashedPassword,
    required super.address,
  })  : bookings = [],
        reviews = [],
        super(userType: UserType.customer);



void handleAdminAction(Admin admin, String action) {
    switch (action) {
      case 'suspend':
        isActive = false;
        print('Account suspended by ${admin.name}');
        break;
      case 'activate':
        isActive = true;
        print('Account activated by ${admin.name}');
        break;
    }
  }
  Review writeReview({
    required int reviewId,
    required ServiceProvider serviceProvider,
    required String comment,
    required int rating, 
  }) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    final hasCompletedBooking = bookings.any(
      (booking) =>
          booking.serviceProvider?.userId == serviceProvider.userId &&
          booking.status == BookingStatus.completed,
    );

    if (!hasCompletedBooking) {
      throw Exception(
          'You can only review service providers you have completed bookings with');
    }

    final alreadyReviewed = reviews.any(
      (review) => review.serviceProvider.userId == serviceProvider.userId,
    );

    if (alreadyReviewed) {
      throw Exception('You have already reviewed this service provider');
    }

    final review = Review(
      reviewId: reviewId,
      comment: comment,
      rating: rating,
      customer: this,
      serviceProvider: serviceProvider,
    );

    reviews.add(review);
    serviceProvider.reviews.add(review);
    serviceProvider.updateAverageRating();

    return review;
  }

  List<Review> getMyReviews() {
    return List<Review>.from(reviews);
  }

  void updateReview(Review review, {String? newComment, int? newRating}) {
    if (!reviews.contains(review)) {
      throw Exception('Review not found');
    }

    if (newComment != null) {
      review.comment = newComment;
    }

    if (newRating != null) {
      if (newRating < 1 || newRating > 5) {
        throw ArgumentError('Rating must be between 1 and 5');
      }
      review.rating = newRating;
      review.serviceProvider.updateAverageRating();
    }
  }

  void deleteReview(Review review) {
    if (reviews.remove(review)) {
      review.serviceProvider.reviews.remove(review);
      review.serviceProvider.updateAverageRating();
    }
  }
}
