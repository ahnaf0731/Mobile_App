import '../models/user.dart';
import '../models/customer.dart';
import '../models/service_provider.dart';
import '../models/service_category.dart';
import '../models/enums.dart';

class AuthService {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock user data - replace with actual API call
    if (email.contains('provider')) {
      _currentUser = ServiceProvider(
        userId: 1,
        name: 'John Provider',
        email: email,
        phoneNumber: '1234567890',
        hashedPassword: password,
        address: '123 Main St',
        serviceCategory: ServiceCategory(
          categoryId: 1,
          name: 'Electrical',
          description: 'Electrical services',
          iconUrl: 'icon.png',
        ),
        bio: 'Experienced electrician',
      );
    } else {
      _currentUser = Customer(
        userId: 2,
        name: 'Jane Customer',
        email: email,
        phoneNumber: '0987654321',
        hashedPassword: password,
        address: '456 Oak Ave',
      );
    }
    
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String address,
    required UserType userType,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (userType == UserType.customer) {
      _currentUser = Customer(
        userId: DateTime.now().millisecondsSinceEpoch,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        hashedPassword: password,
        address: address,
      );
    }
    
    return true;
  }

  void logout() {
    _currentUser = null;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
  }) async {
    if (_currentUser != null) {
      _currentUser!.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
      );
    }
  }
}
