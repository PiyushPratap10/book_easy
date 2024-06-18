import 'package:bookeasy/data/provider_model.dart';
import 'package:bookeasy/presentation/constants/categories.dart';
import 'package:bookeasy/presentation/constants/colors.dart';
import 'package:bookeasy/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class ServiceProviderScreenForCustomer extends StatefulWidget {
  const ServiceProviderScreenForCustomer({super.key, required this.provider});
  final ServiceProvider provider;
  @override
  State<ServiceProviderScreenForCustomer> createState() =>
      _ServiceProviderScreenForCustomerState();
}

class _ServiceProviderScreenForCustomerState
    extends State<ServiceProviderScreenForCustomer> {
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
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 44,
              ),
              CircleAvatar(
                backgroundImage:
                    AssetImage(categoryImages[widget.provider.serviceType]!),
                radius: 60.5,
              ),
              const SizedBox(
                height: 22,
              ),
              Text(
                widget.provider.name,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.provider.serviceType,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 70, 70, 70)),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 120,
                height: 52,
                child: Row(
                  children: [
                    CircularMaroonButton(
                        icon: Icon(
                      Icons.phone_outlined,
                      color: yellowColor,
                      size: 20,
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    CircularMaroonButton(
                        icon: Icon(
                      Icons.message_outlined,
                      color: yellowColor,
                      size: 20,
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.list_rounded,
                          size: 14,
                          color: Color.fromARGB(255, 109, 109, 109),
                        ),
                        Text(
                          '${widget.provider.totalServices} +',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          "Service",
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline_rounded,
                          size: 14,
                          color: Color.fromARGB(255, 109, 109, 109),
                        ),
                        Text(
                          '${widget.provider.totalServices} +',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          "Customers",
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
