import 'package:ecommerce_app_fluterr_nodejs/features/account/services/account_services.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_app_fluterr_nodejs/features/admin/services/admin_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/admin/models/seller_request.dart';

class SellerRequestsScreen extends StatefulWidget {
  const SellerRequestsScreen({Key? key}) : super(key: key);

  @override
  State<SellerRequestsScreen> createState() => _SellerRequestsScreenState();
}

class _SellerRequestsScreenState extends State<SellerRequestsScreen> {
  List<SellerRequest>? requests;
  final AdminServices adminServices = AdminServices();
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchSellerRequests();
  }

  fetchSellerRequests() async {
    requests = await adminServices.fetchSellerRequests(context);
    setState(() {});
  }


  void processRequest(String requestId, String status) {
    adminServices.processSellerRequest(
      context: context,
      requestId: requestId,
      status: status,
      onSuccess: () {
        fetchSellerRequests();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return requests == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: ListView.builder(
              itemCount: requests!.length,
              itemBuilder: (context, index) {
                final request = requests![index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(request.userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.userEmail),
                        const SizedBox(height: 4),
                        Text('Shop: ${request.shopName}'),
                        Text('Description: ${request.shopDescription}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () =>
                              processRequest(request.id, 'approved'),
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              processRequest(request.id, 'rejected'),
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
  }
}
