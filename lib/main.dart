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

      // --- AQUÍ ESTÁN LOS CAMBIOS DE COLOR ---
      theme: ThemeData(
        brightness: Brightness.dark, // Mantenemos el modo oscuro base
        
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFA3), // Tu verde neón característico
          
          // Nuevo color para las TARJETAS y CONTENEDORES (Un gris muy oscuro)
          surface: Color(0xFF1A1F21), // <--- CAMBIO AQUÍ (Gris pizarra oscuro)
          
          // Color para el texto sobre la superficie
          onSurface: Colors.white,
        ),

        // Nuevo color de FONDO GENERAL de la app
        scaffoldBackgroundColor: const Color(0xFF101415), // <--- CAMBIO AQUÍ (Gris-negro profundo)
        
        // OPCIONAL: También puedes personalizar el AppBar si usas uno por defecto
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101415),
          elevation: 0,
        ),
      ),
      // ----------------------------------------

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
        '/register_device': (context) => device.RegisterDevicePage(),
      },
    );
  }
}