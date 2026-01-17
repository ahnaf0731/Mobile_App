

import 'customer.dart';
import 'service_provider.dart';

class Review {
  int reviewId;
  String comment;
  DateTime reviewDate;
  int rating; 
  Customer customer;
  ServiceProvider serviceProvider;

  Review({
    required this.reviewId,
    required this.comment,
    required this.rating,
    required this.customer,
    required this.serviceProvider,
  })  : reviewDate = DateTime.now(),
        assert(rating >= 1 && rating <= 5, 'Rating must be between 1 and 5');

  
  bool isValidRating() {
    return rating >= 1 && rating <= 5;
  }
}