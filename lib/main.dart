import 'package:flutter/material.dart';
import 'src/pages/Welcome/welcome_page.dart';
import 'src/pages/Welcome/welcome_luminous_page.dart';
import 'src/pages/Root/root_page.dart';
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

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'MobileLock AI',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.transparent,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF13E8F3), // Bright Cyan
              secondary: Color(0xFFE01AA9), // Magenta/Pink
              surface: Color(0xFF99CAF1), // Light Blue for cards
              onSurface: Color(0xFF101533),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF101533)),
              titleTextStyle: TextStyle(
                color: Color(0xFF101533),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.transparent,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF629BAD), // Muted Blue/Cyan
              secondary: Color(0xFF920874), // Deep Magenta
              surface: Color(0xFF0C445B), // Dark Blue for cards
              onSurface: Color(0xFFC2C0C5), // Light Gray text
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF101533),
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFFC2C0C5)),
              titleTextStyle: TextStyle(
                color: Color(0xFFC2C0C5),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          themeMode: currentMode,

          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF121727) : null,
                gradient: isDark
                    ? null
                    : const LinearGradient(
                        colors: [
                          Color(0xFF13e8f3),
                          Color(0xFFe01aa9),
                          Color(0xFF655eaf),
                          Color(0xFFa682e8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: child,
            );
          },

          initialRoute: '/',

          routes: {
            '/': (context) => const RootPage(),
            '/welcome': (context) => const WelcomePage(),
            '/welcome_luminous': (context) => const WelcomeLuminousPage(),
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
      },
    );
  }
}

