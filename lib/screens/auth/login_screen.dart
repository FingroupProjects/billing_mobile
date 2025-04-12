import 'package:billing_mobile/bloc/login/login_bloc.dart';
import 'package:billing_mobile/bloc/login/login_event.dart';
import 'package:billing_mobile/bloc/login/login_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/custom_textfield.dart';
import 'package:billing_mobile/home_screen.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();  
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
                showCustomSnackBar(
                  context: context,
                  message: state.message,
                  isSuccess: false,
                );
            } else if (state is LoginLoaded) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Логин',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Введите email и пароль для входа',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff99A4BA),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: emailController, 
                  hintText: 'Введите email',
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Введите пароль',
                  label: 'Пароль',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
                    }
                    return CustomButton(
                      buttonText: 'Войти',
                      buttonColor: const Color(0xff4F40EC),
                      textColor: Colors.white,
                      onPressed: () {
                        final email = emailController.text.trim();  
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          showCustomSnackBar(
                            context: context,
                            message:'Поля не должны быть пустыми!',
                            isSuccess: false,
                          );
                          return;
                        }

                        if (!_isValidEmail(email)) {
                          showCustomSnackBar(
                            context: context,
                            message:'Введите корректный email адрес!',
                            isSuccess: false,
                          );
                          return;
                        }

                        context.read<LoginBloc>().add(CheckLogin(email, password));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}