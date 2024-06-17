// import 'dart:convert';

import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/screens/customer_main_screen.dart';
// import 'package:bookeasy/data/repository/data_repository.dart';
// import 'package:bookeasy/data/user_model.dart';
import 'package:bookeasy/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CostumerSignUpScreen extends StatefulWidget {
  const CostumerSignUpScreen({super.key});

  @override
  State<CostumerSignUpScreen> createState() => _CostumerSignUpScreenState();
}

class _CostumerSignUpScreenState extends State<CostumerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String phone = "";
  String email = "";
  String password = "";

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      const url = "http://10.0.2.2:5000/consumers/signup";

      try {
        await sendFormData(url);
        _handleSuccess(email);
      } catch (e) {
        _handleError('Sign Up Failed: $e');
      }
    }
  }

  Future<void> sendFormData(String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['number'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Form data sent successfully');
      _navigate();
    } else {
      throw Exception('Failed to send form data: ${response.reasonPhrase}');
    }
  }

  void _handleSuccess(String email) async {
    // try {
    //   final User? user = await getUserData(email);

    //   if (user != null) {
    //   } else {
    //     print('User not found');
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
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
                  child: BackNavigationButton(route: "/signup"),
                ),
                const Positioned(
                  top: 34,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 46.5,
                    backgroundColor: Color.fromARGB(255, 221, 116, 18),
                  ),
                ),
                Positioned(
                  top: 169,
                  left: 57,
                  right: 57,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 221, 116, 18),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                ),
                Positioned(
                  top: 248,
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
                  top: 327,
                  left: 57,
                  right: 57,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Number",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 221, 116, 18),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                  ),
                ),
                Positioned(
                  top: 406,
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
                  top: 491,
                  left: 107,
                  right: 107,
                  child: GestureDetector(
                    onTap: _signUp,
                    child: PhysicalModel(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      elevation: 5,
                      child: Container(
                        width: 146,
                        height: 43,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: maroonoColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
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
      ),
    );
  }
}
