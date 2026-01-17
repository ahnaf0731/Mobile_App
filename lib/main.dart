import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/customer/booking_screen.dart';
import 'screens/customer/booking_history_screen.dart';
import 'screens/customer/profile_screen.dart';
import 'screens/customer/review_screen.dart';
import 'screens/provider/provider_dashboard.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FixItNowApp(),
    ),
  );
}

class FixItNowApp extends StatelessWidget {
  const FixItNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixItNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => const BookingScreen(),
        '/booking-history': (context) => const BookingHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/review': (context) {
          // You'll need to pass provider data when navigating
          // For now, using dummy data
          return const ReviewScreen(
            providerName: 'Service Provider',
            providerImage: 'https://i.pravatar.cc/150?img=1',
          );
        },
        '/provider-dashboard': (context) => const ProviderDashboard(),
      },
    );
  }
}
