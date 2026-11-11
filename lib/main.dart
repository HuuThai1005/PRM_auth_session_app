import 'package:flutter/material.dart';

import 'guards/auth_guard.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await SessionService.isLoggedIn();

  runApp(AuthSessionApp(initialLoggedIn: isLoggedIn));
}

class AuthSessionApp extends StatelessWidget {
  final bool initialLoggedIn;

  const AuthSessionApp({
    super.key,
    required this.initialLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Session Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: initialLoggedIn ? '/dashboard' : '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute<void>(
              builder: (_) => const LoginScreen(),
            );

          case '/dashboard':
            return MaterialPageRoute<void>(
              builder: (_) => const DashboardScreen(),
            );

          case '/profile':
            return MaterialPageRoute<void>(
              builder: (_) {
                return FutureBuilder<bool>(
                  future: AuthGuard.check(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.data != true) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (_) => false,
                          );
                        }
                      });

                      return const Scaffold(
                        body: Center(child: Text('Đang chuyển về Login...')),
                      );
                    }

                    return const ProfileScreen();
                  },
                );
              },
            );

          default:
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(
                body: Center(child: Text('404 - Route not found')),
              ),
            );
        }
      },
    );
  }
}