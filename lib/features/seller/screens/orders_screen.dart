import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/single_product.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/services/seller_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/order_details/screens/order_details_screens.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orderList;
  final SellerServices _sellerServices = SellerServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrders();
  }

  void getAllOrders() async {
    orderList = await _sellerServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orderList == null
        ? const Center(child: CircularProgressIndicator())
        : orderList!.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 120,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Orders Yet!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your orders will appear here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                itemCount: orderList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final order = orderList![index];
                  return Column(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              OrderDetailsScreens.routeName,
                              arguments: order,
                            );
                          },
                          child: SingleProduct(
                            image: order.products[0].images[0],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Order ${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
  }
}
