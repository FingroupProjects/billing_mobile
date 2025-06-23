import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/BusinessType/BusinessType_bloc.dart';
import 'package:billing_mobile/bloc/Country/Country_bloc.dart';
import 'package:billing_mobile/bloc/client_history/client_history_bloc.dart';
import 'package:billing_mobile/bloc/clients/NfrClientBloc.dart';
import 'package:billing_mobile/bloc/clients/clients_bloc.dart';
import 'package:billing_mobile/bloc/clients_InActive/InActive_clients_bloc.dart';
import 'package:billing_mobile/bloc/clients_by_id/clientById_bloc.dart';
import 'package:billing_mobile/bloc/clients_demo/demo_clients_bloc.dart';
import 'package:billing_mobile/bloc/currency/currency_bloc.dart';
import 'package:billing_mobile/bloc/login/login_bloc.dart';
import 'package:billing_mobile/bloc/organizations/organizations_bloc.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_bloc.dart';
import 'package:billing_mobile/bloc/partners/partners_bloc.dart';
import 'package:billing_mobile/bloc/sale/sale_bloc.dart';
import 'package:billing_mobile/bloc/tariff/tariff_bloc.dart';
import 'package:billing_mobile/bloc/transactions/transactions_bloc.dart';
import 'package:billing_mobile/bloc/transactionsById/transactionsById_bloc.dart';
import 'package:billing_mobile/home_screen.dart';
import 'package:billing_mobile/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart'; // Add this for Android secure flag

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  );

  // Disable screenshots and screen recording on Android
  // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

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
        BlocProvider(create: (context) => LoginBloc(apiService)),
        BlocProvider(create: (context) => ClientBloc(apiService: apiService)),
        BlocProvider(create: (context) => NfrClientBloc(apiService: apiService)),
        BlocProvider(create: (context) => DemoBloc(apiService: apiService)),
        BlocProvider(create: (context) => InActiveBloc(apiService: apiService)),
        BlocProvider(create: (context) => ClientByIdBloc(apiService)),
        BlocProvider(create: (context) => OrganizationBloc(apiService: apiService)),
        BlocProvider(create: (context) => OrganizationByIdBloc(apiService: apiService)),
        BlocProvider(create: (context) => PartnerBloc(apiService: apiService)),
        BlocProvider(create: (context) => SaleBloc(apiService: apiService)),
        BlocProvider(create: (context) => CountryBloc(apiService: apiService)),
        BlocProvider(create: (context) => BusinessTypeBloc(apiService: apiService)),
        BlocProvider(create: (context) => TransactionBloc(apiService: apiService)),
        BlocProvider(create: (context) => TransactionByIdBloc(apiService: apiService)),
        BlocProvider(create: (context) => ClientHistoryBloc(apiService)),
        BlocProvider(create: (context) => CurrencyBloc(apiService: apiService)),
        BlocProvider(create: (context) => TariffBloc(apiService: apiService)),
        
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: 'shamPartners',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: token == null ? const LoginScreen() : HomeScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}