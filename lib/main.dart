import 'package:flutter/material.dart';
import 'src/pages/Welcome/welcome_page.dart';
import 'src/pages/Login/login_page.dart';
import 'src/pages/Register/register_page.dart' as user;
import 'src/pages/Dashboard/dashboard_page.dart';
import 'src/pages/Profile/profile_page.dart';
import 'src/pages/Profile/edit_profile_page.dart';
import 'src/pages/Profile/change_password_page.dart';
import 'src/pages/Device/devices_page.dart';
import 'src/pages/Device/register_device_page.dart' as device;
import 'src/pages/Device/verify_device_page.dart';
import 'src/pages/Device/scan_history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobileLock AI',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark, 
        
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFA3), 
          surface: Color(0xFF1A1F21), 
          onSurface: Colors.white,
        ),

        scaffoldBackgroundColor: const Color(0xFF101415), 
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101415),
          elevation: 0,
        ),
      ),

      initialRoute: '/login', 

      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const user.RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/change_password': (context) => const ChangePasswordPage(),
        '/devices': (context) => const DevicesPage(),
        '/register_device': (context) => const device.RegisterDevicePage(),
        '/verify_device': (context) => const VerifyDevicePage(),
        '/scan_history': (context) => const ScanHistoryPage(),
      },
    );
  }
}