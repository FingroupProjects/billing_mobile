import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/login/login_bloc.dart';
import 'package:billing_mobile/home_screen.dart';
import 'package:billing_mobile/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  );

  final apiService = ApiService();
  final String? token = await apiService.getToken();

  runApp(MyApp(
    token: token,
    apiService: apiService,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  final ApiService apiService;

  const MyApp({
    super.key,
    this.token,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(apiService),
        ),
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: 'billing',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: token == null ? const LoginScreen()
            : HomeScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}