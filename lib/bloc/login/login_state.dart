
import 'package:billing_mobile/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final String token;
  final User user;
  final String role; // Добавляем поле role

  const LoginLoaded({
    required this.token,
    required this.user,
    required this.role,
  });

  @override
  List<Object> get props => [token, user, role];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}