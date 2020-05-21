import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory/services/api/api_constants.dart';
import 'package:inventory/models/constants.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/models/user_preference.dart';
import 'package:inventory/services/api/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService implements AuthService {

  Timer _authTimer;
  User _authenticatedUser;


  User get user {
    return _authenticatedUser;
  }

  static StreamController<void> _isTimeoutController = StreamController<void>();
  final Stream<void> _isTimeoutStream = _isTimeoutController.stream;

  @override
  void dispose() {
    _isTimeoutController.close();
  }

  Stream<void> get isTimeoutStream {
    return _isTimeoutStream;
  }

  @override
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        ApiConstants.AUTH_VERIFY_PASSWORD,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        ApiConstants.AUTH_SIGN_UP,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Authentication error';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setPrefs(
          userId: responseData['localId'],
          userEmail: email,
          token: responseData['idToken'],
          expiryTime: expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    return {'success': !hasError, 'message': message};
  }

  @override
  Future<bool> autoLogin() async {
    final prefs = await getPrefs();

    if (prefs.expiryTime != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(prefs.expiryTime);
      if (parsedExpiryTime.isBefore(now) || prefs.token == null) {
        _authenticatedUser = null;
        return false;
      }
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser =
          User(id: prefs.userId, email: prefs.userEmail, token: prefs.token);
      setAuthTimeout(tokenLifespan);
      return true;
    } else
      return false;
  }

  Future<UserPreference> getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userEmail = prefs.getString('userEmail');
    final token = prefs.getString('token');
    final expiryTime = prefs.getString('expiryTime');

    return UserPreference(userId, userEmail, token, expiryTime);
  }

  void setPrefs (
      {String userId,
      String userEmail,
      String token,
      String expiryTime}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userId != null) prefs.setString('userId', userId);
    if (userEmail != null) prefs.setString('userEmail', userEmail);
    if (token != null) prefs.setString('token', token);
    if (token != null) prefs.setString('expiryTime', expiryTime);
  }

  void removePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  @override
  Future<void> logout() async {
    _authenticatedUser = null;
    _authTimer?.cancel();
    removePrefs();
    _isTimeoutController.add(null);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

}
