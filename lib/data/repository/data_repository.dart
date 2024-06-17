import 'package:bookeasy/data/provider_model.dart';
// import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/data/user_model.dart';
import 'package:bookeasy/presentation/widgets/home_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User?> getUserData(String email) async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:5000/consumers/get/$email'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return User.fromJson(data);
  } else {
    throw Exception('Failed to load user data');
  }
}

Future<List<Widget>> popularProvider() async {
  List<Widget> popularServices = [];
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/providers/popular'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      List<ServiceProvider> providers =
          data.map((item) => ServiceProvider.fromJson(item)).toList();
      for (var provider in providers) {
        popularServices.add(PopularServiceWidget(provider: provider));
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }

  if (popularServices.isEmpty) {
    popularServices.add(const Text('No popular providers found'));
  }

  return popularServices;
}

Future<List<Widget>> getProviderByCategory(String category) async {
  List<Widget> list = [];
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:5000/providers/service/$category'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List<dynamic>;
      List<ServiceProvider> providerList =
          data.map((e) => ServiceProvider.fromJson(e)).toList();
      for (var provider in providerList) {
        list.add(ServiceProviderCard(provider: provider));
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }

  if (list.isEmpty) {
    list.add(const Text("No services available for this category"));
  }

  return list;
}
