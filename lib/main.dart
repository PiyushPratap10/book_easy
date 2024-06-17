import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/presentation/screens/costumer_home_screen.dart';
import 'package:bookeasy/presentation/screens/costumer_signup_screen.dart';
import 'package:bookeasy/presentation/screens/coustmer_login_screen.dart';
import 'package:bookeasy/presentation/screens/customer_main_screen.dart';
import 'package:bookeasy/presentation/screens/first_screen.dart';
import 'package:bookeasy/presentation/screens/provider_login_screen.dart';
import 'package:bookeasy/presentation/screens/provider_signup_screen.dart';
import 'package:bookeasy/presentation/screens/services_screen.dart';
import 'package:bookeasy/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ListProvider()),
        ChangeNotifierProvider(create: (ctx) => BottomNavigationProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const FirstScreen(),
          "/costumer/login": (context) => const CostumerLoginScreen(),
          "/provider/login": (context) => const ProviderLoginScreen(),
          "/costumer/signup": (context) => const CostumerSignUpScreen(),
          "/provider/signup": (context) => const ProviderSignUpScreen(),
          "/signup": (context) => const SignUpScreen(),
          "/customer/main":(context) => const CustomerMainScreen(),
          "/costumer/home":(context) => const CostumerHomeScreen(),
          "/customer/services":(context) => const ServicesScreen()
        },
      ),
    );
  }
}
