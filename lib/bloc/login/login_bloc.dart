import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/models/login_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_mobile/models/user.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'dart:io';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc(this.apiService) : super(LoginInitial()) {
    on<CheckLogin>((event, emit) async {
      emit(LoginLoading());
      if (await _checkInternetConnection()) {
        try {
          final loginModel = LoginModel(login: event.login, password: event.password);
          final loginResponse = await apiService.login(loginModel);
          // Передаём токен, пользователя и роль в состояние LoginLoaded
          emit(LoginLoaded(
            token: loginResponse.token,
            user: loginResponse.user,
            role: loginResponse.role, // Добавляем роль
          ));
        } catch (e) {
          emit(LoginError(e.toString()));
        }
      } else {
        emit(LoginError('Нет подключения к интернету'));
      }
    });
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}