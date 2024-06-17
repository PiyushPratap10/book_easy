import 'package:bookeasy/data/provider_model.dart';
import 'package:bookeasy/data/user_model.dart';
import 'package:bookeasy/presentation/constants/categories.dart';
import 'package:flutter/material.dart';

class ListProvider extends ChangeNotifier {
  List<User> userList = [];

  List<ServiceProvider> popularProviderList = [];
  String selectedCategory = categories[0];

  void addUser(User user) {
    userList.add(user);
    notifyListeners();
  }

  void addPopularServices(ServiceProvider provider) {
    popularProviderList.add(provider);
    notifyListeners();
  }

  void changeCategory(String category) {
    if (categories.contains(category)) {
      selectedCategory = category;
    }
    notifyListeners();
  }
}

class BottomNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}