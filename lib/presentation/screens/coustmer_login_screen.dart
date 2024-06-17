import 'dart:convert';

import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/data/repository/data_repository.dart';
import 'package:bookeasy/data/user_model.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
// import 'package:bookeasy/presentation/functions/routing_functions.dart';
import 'package:bookeasy/presentation/screens/costumer_home_screen.dart';
import 'package:bookeasy/presentation/screens/customer_main_screen.dart';
import 'package:bookeasy/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CostumerLoginScreen extends StatefulWidget {
  const CostumerLoginScreen({super.key});

  @override
  State<CostumerLoginScreen> createState() => _CostumerLoginScreenState();
}

class _CostumerLoginScreenState extends State<CostumerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  Future<void> _signIn(ListProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      const url = "http://10.0.2.2:5000/consumers/signin";
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        _handleSuccess(email, provider);
        _navigate();
      } else {
        _handleError('Sign In Failed: ${response.body}');
      }
    }
  }

  void _handleSuccess(String email, ListProvider provider) async {
    try {
      final User? user = await getUserData(email);
      if (user != null) {
        provider.addUser(user);

        print(provider.userList);
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CustomerMainScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(
        builder: (context, provider, child) => Scaffold(
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      const Positioned(
                        top: 20,
                        left: 20,
                        child: BackNavigationButton(route: "/"),
                      ),
                      const Positioned(
                        top: 60,
                        left: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 62,
                          backgroundColor: Color.fromARGB(255, 221, 116, 18),
                        ),
                      ),
                      Positioned(
                        top: 252,
                        left: 57,
                        right: 57,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 221, 116, 18),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                      ),
                      Positioned(
                        top: 344,
                        left: 57,
                        right: 57,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 221, 116, 18),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          obscureText: true,
                          onSaved: (value) {
                            password = value!;
                          },
                        ),
                      ),
                      Positioned(
                        top: 440,
                        left: 107,
                        right: 107,
                        child: GestureDetector(
                          onTap: () {
                            _signIn(provider);
                          },
                          child: Container(
                            width: 146,
                            height: 43,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: maroonoColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 490,
                        left: 110,
                        right: 110,
                        child: InkWell(
                          onTap: () {
                            // Add your forgot password logic here
                          },
                          child: const Text(
                            "Forgot Password ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 106, 204),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          left: -30,
                          top: 520,
                          bottom: -70,
                          right: 145,
                          child: Image.asset(
                            "assets/images/consumer.png",
                            width: 272,
                            height: 272,
                          ))
                    ],
                  ),
                ),
              ),
            ));
  }
}
