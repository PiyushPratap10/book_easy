import 'package:bookeasy/presentation/constants/categories.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/widgets/home_screen_widget.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: maroonoColor,
        title: Text(
          "Services",
          style: TextStyle(color: yellowColor),
        ),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 22, crossAxisSpacing: 14, crossAxisCount: 3),
          itemBuilder: (context, index) {
            String cat = categories[index];
            String logo = categoryLogos[cat]!;
            return ServiceCard(title: cat, logoPath: logo);
          }),
    );
  }
}
