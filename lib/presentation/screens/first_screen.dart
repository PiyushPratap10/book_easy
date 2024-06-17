import 'package:bookeasy/presentation/functions/routing_functions.dart';
import 'package:bookeasy/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 62,
              backgroundColor: Color.fromARGB(255, 221, 116, 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Welcome !",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(
              height: 27,
            ),
            const Text(
              "Login to your account",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 46,
            ),
            const LargeNavigatorButton(
              width: 210,
              title: "Costumer",
              route: "/costumer/login",
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "or",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            const LargeNavigatorButton(
                width: 210,
                title: "Service Provider",
                route: "/provider/login"),
            const SizedBox(
              height: 35,
            ),
            const Text(
              "Don't have an account ?",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                navigation(context, "/signup");
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 106, 204),
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromARGB(255, 0, 106, 204),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
