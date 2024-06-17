import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/screens/costumer_home_screen.dart';
import 'package:bookeasy/presentation/screens/customer_bookings_screen.dart';
import 'package:bookeasy/presentation/screens/customer_profile_screen.dart';
import 'package:bookeasy/presentation/screens/services_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final List<Widget> _pages = [
    const CostumerHomeScreen(),
    const ServicesScreen(),
    const CustomerBookingsScreen(),
    const CustomerProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavProvider, child) {
        return Scaffold(
          backgroundColor: background,
          bottomNavigationBar: CurvedNavigationBar(
            buttonBackgroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            color: maroonoColor,
            animationDuration: const Duration(milliseconds: 300),
            onTap: (index) {
              setState(() {
                bottomNavProvider.setIndex(index);
              });
            },
            items: [
              Icon(Icons.home_rounded, color: yellowColor),
              Icon(Icons.miscellaneous_services, color: yellowColor),
              Icon(Icons.list_alt_rounded, color: yellowColor),
              Icon(Icons.person_rounded, color: yellowColor),
            ],
          ),
          body: SafeArea(
            child: _pages[bottomNavProvider.currentIndex],
          ),
        );
      },
    );
  }
}
