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
  final String role; // Добавляем поле role

  LoginResponse({
    required this.token,
    required this.user,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromMap(json['user']),
      role: json['user']['role'], // Извлекаем role из user
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toMap(),
      'role': role,
    };
  }
}