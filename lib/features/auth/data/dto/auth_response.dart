class AuthResponse {
  final String accessToken;
  final AuthUser user;

  const AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>;

    return AuthResponse(
      accessToken: result['accessToken'] as String,
      user: AuthUser.fromJson(result['user'] as Map<String, dynamic>),
    );
  }
}

class AuthUser {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

