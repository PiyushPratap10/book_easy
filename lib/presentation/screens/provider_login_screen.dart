import 'dart:convert';

import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderLoginScreen extends StatefulWidget {
  const ProviderLoginScreen({super.key});

  @override
  State<ProviderLoginScreen> createState() => _ProviderLoginScreenState();
}

class _ProviderLoginScreenState extends State<ProviderLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      const url = "http://10.0.2.2:5000/providers/signin";
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
        // Verification successful
        _handleSuccess();
      } else {
        // Verification failed
        _handleError('Sign In Failed: ${response.body}');
      }
    }
  }

  void _handleSuccess() {
    // Handle successful verification
    // For example, navigate to a new screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsScreen(userData)));
  }

  void _handleError(String errorMessage) {
    // Handle error by displaying a snackbar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: _signIn,
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                  bottom: -70,
                  top: 520,
                  child: Image.asset(
                    "assets/images/consumer.png",
                    width: 272,
                    height: 272,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
