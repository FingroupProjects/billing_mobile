import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckLogin extends LoginEvent {
  final String email;
  final String password;

  CheckLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}