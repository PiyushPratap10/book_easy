import 'package:bookeasy/data/provider_model.dart';
import 'package:bookeasy/data/providers/list_provider.dart';
import 'package:bookeasy/presentation/constants/categories.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumerHomeScreenSearchBox extends StatelessWidget {
  const CostumerHomeScreenSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 50.0,
              width: 314.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellowColor, maroonoColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  2.0), // Adjust padding to show gradient border
              child: Container(
                height: 46.0,
                width: 310.0,
                decoration: BoxDecoration(
                  color: Colors.white, // Inner container color
                  borderRadius: BorderRadius.circular(23.0),
                ),
                child: const Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    Text(
                      'Search...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  const CustomSliverAppBarDelegate({
    required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 60;
    final top = expandedHeight - shrinkOffset - size / 2;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset),
        buildAppBar(shrinkOffset),
        Positioned(
          top: top,
          left: 23,
          right: 23,
          bottom: -21,
          child: buildFloating(shrinkOffset),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(double shrinkOffset) => Opacity(
        opacity: appear(shrinkOffset),
        child: AppBar(
          title: const Text("BookEasy"),
        ),
      );

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
                child: Container(
              color: maroonoColor,
            )),
            Positioned(
                top: 41,
                bottom: 41,
                left: 21,
                right: 245,
                child: CircleAvatar(
                  radius: 47,
                  backgroundColor: yellowColor,
                )),
            Positioned(
                left: 289,
                top: 64,
                bottom: 64,
                right: 23,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: popularServiceBackground,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 28,
                        color: Color.fromARGB(255, 14, 98, 197),
                      )),
                )),
          ],
        ),
      );

  Widget buildFloating(double shrinkOffset) => Opacity(
      opacity: disappear(shrinkOffset),
      child: const CostumerHomeScreenSearchBox());

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class PopularServiceWidget extends StatelessWidget {
  const PopularServiceWidget({super.key, required this.provider});
  final ServiceProvider provider;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 149,
        height: 164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: popularServiceBackground,
            border: Border.all(width: 1, color: maroonoColor),
            borderRadius: BorderRadius.circular(9)),
        child: Column(
          children: [
            CircleAvatar(
              radius: 31,
              backgroundImage:
                  AssetImage(categoryImages[provider.serviceType]!),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              provider.name,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              provider.serviceType,
              style: const TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 70, 70, 70)),
            ),
            const SizedBox(
              height: 11,
            ),
            BookingButton(
              provider: provider,
            )
          ],
        ),
      ),
    );
  }
}

class BookingButton extends StatelessWidget {
  const BookingButton({super.key, required this.provider});
  final ServiceProvider provider;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 84,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: yellowColor, borderRadius: BorderRadius.circular(14)),
        child: Text(
          "BOOK NOW",
          style: TextStyle(fontSize: 13, color: maroonoColor),
        ),
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  const CategoryItem(
      {super.key,
      required this.category,
      required this.textColor,
      required this.backgroundColor});
  final String category;
  final Color textColor;
  final Color backgroundColor;
  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: () {
          setState(() {
            provider.changeCategory(widget.category);
          });
        },
        child: Container(
          height: 34,
          width: 118,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: widget.textColor),
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(18)),
          child: Text(
            widget.category,
            style: TextStyle(fontSize: 18, color: widget.textColor),
          ),
        ),
      ),
    );
  }
}

class ViewAllButton extends StatefulWidget {
  const ViewAllButton({
    super.key,
  });

  @override
  State<ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<ViewAllButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Provider.of<BottomNavigationProvider>(context, listen: false)
              .setIndex(1);
        });
      },
      child: Container(
        height: 34,
        width: 118,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 184, 178, 255),
            border: Border.all(color: const Color.fromARGB(255, 109, 33, 206)),
            borderRadius: BorderRadius.circular(18)),
        child: const Text(
          "View All",
          style:
              TextStyle(fontSize: 18, color: Color.fromARGB(255, 109, 33, 206)),
        ),
      ),
    );
  }
}

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({super.key, required this.provider});
  final ServiceProvider provider;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 332,
      margin: const EdgeInsets.fromLTRB(0, 13, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: 125,
              height: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: yellowColor,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(categoryImages[provider.serviceType]!)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(
                          64,
                          0,
                          0,
                          0,
                        ),
                        offset: Offset(1, 0),
                        blurRadius: 2)
                  ]),
            )),
        Positioned(
            top: 11,
            left: 134,
            // right: 110,
            bottom: 82,
            child: Text(
              provider.name,
              style: const TextStyle(fontSize: 14),
            )),
        Positioned(
            top: 33,
            bottom: 61,
            left: 134,
            child: Text(
              provider.serviceType,
              style: const TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 70, 70, 70)),
            )),
        Positioned(
            top: 55,
            bottom: 39,
            left: 134,
            child: Text(
              "Services - ${provider.totalServices}+",
              style: const TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 70, 70, 70)),
            )),
        Positioned(
            top: 46,
            bottom: 42,
            left: 236,
            child: Text(
              "Rs. ${provider.charge}",
              style: const TextStyle(fontSize: 19),
            )),
        Positioned(
            top: 73,
            bottom: 12,
            left: 236,
            right: 12,
            child: BookingButton(provider: provider))
      ]),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.title, required this.logoPath});
  final String title;
  final String logoPath;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 102,
        width: 102,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.71),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover,image: AssetImage(logoPath))
              ),
            ),
            const SizedBox(height: 12,),
            Text(title,style: const TextStyle(fontSize: 11.65),)
          ],
        ),
      ),
    );
  }
}

