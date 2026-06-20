import 'package:flutter/material.dart';
import '../../../services/auth_storage.dart';
import '../Profile/profile_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Read cached authentication token and user email from storage
    final token = await AuthStorage.getToken();
    final email = await AuthStorage.getEmail();

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        // Initialize global session parameters
        isLoggedIn = true;
        globalToken = token;
        currentEmail = email ?? "invitado@mail.com";

        // Route directly to dashboard bypassing welcome/login
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Navigate to the onboarding screen
        Navigator.pushReplacementNamed(context, '/welcome_luminous');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121727),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00F0FF),
        ),
      ),
    );
  }
}
