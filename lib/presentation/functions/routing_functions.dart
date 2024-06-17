import 'package:flutter/material.dart';

void navigation(BuildContext context, String route) {
  Navigator.pushNamed(context, route);
}

void backNavigation(BuildContext context, String route) {
  Navigator.popAndPushNamed(context, route);
}

