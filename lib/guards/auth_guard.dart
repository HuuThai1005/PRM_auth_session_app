import '../services/session_service.dart';

class AuthGuard {
  static Future<bool> check() {
    return SessionService.isLoggedIn();
  }
}