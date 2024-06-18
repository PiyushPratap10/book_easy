import 'package:bookeasy/data/repository/data_repository.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:flutter/material.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key, required this.category});
  final String category;

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: maroonoColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.navigate_before_rounded,
              color: yellowColor,
            )),
        title: Text(
          "Services List",
          style: TextStyle(fontSize: 20, color: yellowColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: getProviderByCategory(widget.category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else if (snapshot.hasError) {
                    return Text("Error : ${snapshot.error}");
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: snapshot.data!,
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
