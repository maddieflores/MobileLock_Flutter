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

      // Aplicamos un tema oscuro global para que combine con tu interfaz
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(
            0xFF00FFA3,
          ), // Esto aplica el verde a más componentes
          surface: const Color(0xFF14191A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E0F),
      ),

      // 1. La pantalla que se verá apenas abra la app
      initialRoute: '/login',

      // 2. El "Mapa" de navegación hacia tus nuevas carpetas
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const user.RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/change_password': (context) => const ChangePasswordPage(),
        '/devices': (context) => const DevicesPage(),
        '/register_device': (context) => device.RegisterDevicePage(),
      },
    );
  }
}
