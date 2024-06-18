import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/functions/routing_functions.dart';
import 'package:flutter/material.dart';

class LargeNavigatorButton extends StatelessWidget {
  const LargeNavigatorButton({
    super.key,
    required this.width,
    required this.title,
    required this.route,
  });
  final double width;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigation(context, route);
      },
      child: Container(
        width: width,
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: maroonoColor,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class BackNavigationButton extends StatelessWidget {
  const BackNavigationButton({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        backNavigation(context, route);
      },
      child: Container(
        width: 87,
        height: 31,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: maroonoColor, borderRadius: BorderRadius.circular(5)),
        child: const Text(
          "Back",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class CircularMaroonButton extends StatelessWidget {
  const CircularMaroonButton({super.key, required this.icon});
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: CircleAvatar(
        backgroundColor: maroonoColor,
        radius: 26,
        child: Center(child: icon),
      ),
    );
  }
}