import 'package:inventory/models/user.dart';
import 'package:inventory/models/constants.dart';

abstract class AuthService {
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]);

  Future<void> logout();

  Future<bool> autoLogin();

  void dispose();

  Stream<void> get isTimeoutStream;

    User get user;

}
