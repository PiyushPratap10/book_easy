// import 'package:bookeasy/data/provider_model.dart';
// import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/data/repository/data_repository.dart';
import 'package:bookeasy/presentation/constants/categories.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
// import 'package:bookeasy/presentation/functions/widgets_functions.dart';
import 'package:bookeasy/presentation/widgets/home_screen_widget.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumerHomeScreen extends StatefulWidget {
  const CostumerHomeScreen({super.key});

  @override
  State<CostumerHomeScreen> createState() => _CostumerHomeScreenState();
}

class _CostumerHomeScreenState extends State<CostumerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(
        builder: (context, provider, child) => Scaffold(
              backgroundColor: background,
              body: SafeArea(
                child: CustomScrollView(
                  clipBehavior: Clip.none,
                  slivers: [
                    const SliverPersistentHeader(
                        delegate:
                            CustomSliverAppBarDelegate(expandedHeight: 176)),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 42,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                        child: Row(
                          children: [
                            Text(
                              "Popular Services",
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FutureBuilder(
                          future: popularProvider(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error : ${snapshot.error}");
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: snapshot.data!,
                                ),
                              );
                            }
                          }),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 21,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                        child: Row(
                          children: [
                            Text(
                              "Categories",
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 9, 14, 0),
                          child: Row(
                            children: [
                              CategoryItem(
                                  category: categories[0],
                                  textColor: foregroundBlue,
                                  backgroundColor: backgroundBlue),
                              const SizedBox(
                                width: 22,
                              ),
                              CategoryItem(
                                  category: categories[1],
                                  textColor: foregroundGreen,
                                  backgroundColor: backgroundGreen),
                              const SizedBox(
                                width: 22,
                              ),
                              CategoryItem(
                                  category: categories[2],
                                  textColor: foregroundRed,
                                  backgroundColor: backgroundRed),
                              const SizedBox(
                                width: 22,
                              ),
                              CategoryItem(
                                  category: categories[4],
                                  textColor: foregroundYellow,
                                  backgroundColor: backgroundYellow),
                              const SizedBox(
                                width: 22,
                              ),
                              const ViewAllButton()
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FutureBuilder(
                          future:
                              getProviderByCategory(provider.selectedCategory),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator.adaptive();
                            } else if (snapshot.hasError) {
                              return Text("Error : ${snapshot.error}");
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: snapshot.data!,
                              );
                            }
                          })),
                    )
                  ],
                ),
              ),
            ));
  }
}
