
import 'enums.dart';

class User {
  int userId;
  String name;
  String email;
  String phoneNumber;
  String hashedPassword;
  String address;
  UserType userType;
  bool isActive; 
  DateTime createdAt; 

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.hashedPassword,
    required this.address,
    required this.userType,
  }) : isActive = true, 
        createdAt = DateTime.now(); 

  
  void register() {
    
    print('User $name registered successfully');
  }

  bool login(String email, String password) {
   
    return this.email == email && _verifyPassword(password);
  }

  void updateProfile({String? name, String? email, String? phoneNumber, String? address}) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.address = address ?? this.address;
  }

  bool _verifyPassword(String password) {
  
    return true;
  }
}