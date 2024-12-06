import 'package:flutter/material.dart';

import 'package:ecommerce_app_fluterr_nodejs/features/admin/services/admin_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/user.dart';

class SellersScreen extends StatefulWidget {
  const SellersScreen({Key? key}) : super(key: key);

  @override
  State<SellersScreen> createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  List<User>? sellers;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchSellers();
  }

  fetchSellers() async {
    sellers = await adminServices.fetchSellers(context);
    setState(() {});
  }

  void disableSeller(String sellerId) {
    adminServices.disableSeller(
      context: context,
      sellerId: sellerId,
      onSuccess: () {
        fetchSellers();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return sellers == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: ListView.builder(
              itemCount: sellers!.length,
              itemBuilder: (context, index) {
                final seller = sellers![index];
                return ListTile(
                  title: Text(seller.name),
                  subtitle: Text(seller.email),
                  trailing: IconButton(
                    onPressed: () => disableSeller(seller.id),
                    icon: const Icon(
                      Icons.block,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          );
  }
}