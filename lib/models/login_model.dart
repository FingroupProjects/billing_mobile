import 'package:billing_mobile/models/user.dart';

class LoginModel {
  final String login;  // Изменено с login на email
  final String password;

  LoginModel({required this.login, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'login': login,  
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromMap(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toMap(),
    };
  }
}