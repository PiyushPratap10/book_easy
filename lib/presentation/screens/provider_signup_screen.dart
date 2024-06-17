import 'dart:convert';

import 'package:bookeasy/presentation/constants/categories.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderSignUpScreen extends StatefulWidget {
  const ProviderSignUpScreen({super.key});

  @override
  State<ProviderSignUpScreen> createState() => _ProviderSignUpScreenState();
}

class _ProviderSignUpScreenState extends State<ProviderSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String phone = "";
  String email = "";
  String password = "";
  String service = categories[0];

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      const url = "http://10.0.2.2:5000/providers/signup";

      try {
        await sendFormData(url);
      } catch (e) {
        _handleError("Sign up failed: $e");
      }
    }
  }

  Future<void> sendFormData(String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['number'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['service_type'] = service;

    var response = await request.send();

    if (response.statusCode == 200) {
      _handleSuccess();
    } else {
      throw Exception('Failed to send form data: ${response.reasonPhrase}');
    }
  }

  void _handleSuccess() {
    // Handle successful signup
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
                left: 57,
                right: 57,
                child: DropdownButtonFormField<String>(
                  value: service,
                  hint: const Text('Service Type'),
                  items: categories.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      service = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                ),
              ),
              Positioned(
                  right: -35,
                  bottom: -31,
                  top: 520,
                  child: Image.asset(
                    "assets/images/provider.png",
                    width: 230,
                    height: 230,
                  )),
              Positioned(
                top: 576,
                left: 107,
                right: 107,
                child: GestureDetector(
                  onTap: _signUp,
                  child: PhysicalModel(
                    color: Colors.white,
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(5.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
