import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lpaecomms/app/state/app_state_provider.dart';

/// Thrown when the authentication backend returns an error.
class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Provides a lightweight wrapper around the remote authentication endpoint.
class AuthRepository {
  AuthRepository({http.Client? httpClient, String? loginEndpoint})
      : _httpClient = httpClient ?? http.Client(),
        _loginEndpoint = (loginEndpoint ??
                const String.fromEnvironment(
                  'LOGIN_ENDPOINT',
                  defaultValue: 'http://10.0.2.2:8000/api/mobile/login',
                ))
            .trim();

  final http.Client _httpClient;
  final String _loginEndpoint;

  /// Attempts to authenticate a user against the remote backend.
  ///
  /// The default endpoint can be overridden at build time with
  /// `--dart-define=LOGIN_ENDPOINT=https://example.com/api/login` or by
  /// providing a [loginEndpoint] through Riverpod overrides in tests.
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    if (_loginEndpoint.isEmpty) {
      throw AuthException('Login endpoint is not configured.');
    }

    final uri = Uri.parse(_loginEndpoint);
    final response = await _httpClient.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _parseSession(response.body, fallbackEmail: email);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Invalid email or password.');
    }

    throw AuthException(
      'Login failed with status ${response.statusCode}. Please try again later.',
    );
  }

  AuthSession _parseSession(String body, {required String fallbackEmail}) {
    Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        payload = decoded;
      } else {
        throw const FormatException('Unexpected response format');
      }
    } on FormatException catch (error) {
      throw AuthException('Unable to read login response: ${error.message}');
    }

    // Some APIs wrap the actual payload in a `data` key.
    final data = payload['data'];
    final Map<String, dynamic> bodyMap =
        data is Map<String, dynamic> ? data : payload;

    final dynamic rawUserId = bodyMap['userId'] ??
        bodyMap['user_id'] ??
        bodyMap['id'] ??
        bodyMap['lpa_users_ID'];
    final dynamic rawEmail = bodyMap['email'] ??
        bodyMap['user_email'] ??
        bodyMap['lpa_user_email'] ??
        fallbackEmail;
    final dynamic rawToken = bodyMap['token'] ??
        bodyMap['access_token'] ??
        bodyMap['jwt'] ??
        bodyMap['api_token'];

    if (rawUserId == null) {
      throw AuthException('Login response did not include a user identifier.');
    }

    final String email = rawEmail is String ? rawEmail : fallbackEmail;

    return AuthSession(
      userId: rawUserId.toString(),
      email: email,
      displayName: _buildDisplayName(bodyMap),
      token: rawToken is String ? rawToken : null,
    );
  }

  String? _buildDisplayName(Map<String, dynamic> body) {
    final dynamic explicitName =
        body['name'] ?? body['fullName'] ?? body['full_name'];
    if (explicitName is String && explicitName.trim().isNotEmpty) {
      return explicitName.trim();
    }

    final dynamic first = body['first_name'] ??
        body['firstname'] ??
        body['lpa_user_firstname'];
    final dynamic last =
        body['last_name'] ?? body['lastname'] ?? body['lpa_user_lastname'];

    final parts = <String>[];
    if (first is String && first.trim().isNotEmpty) {
      parts.add(first.trim());
    }
    if (last is String && last.trim().isNotEmpty) {
      parts.add(last.trim());
    }

    if (parts.isEmpty) {
      return null;
    }

    return parts.join(' ');
  }
}
