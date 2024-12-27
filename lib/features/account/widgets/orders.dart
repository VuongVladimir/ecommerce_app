import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/services/account_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/single_product.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/order_details/screens/order_details_screens.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orderList;
  final AccountServices _accountServices = AccountServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyOrders();
  }

  void getMyOrders() async {
    orderList = await _accountServices.fetchOrders(context);
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
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Số cột
                          childAspectRatio: 1, // Tỷ lệ khung hình
                          crossAxisSpacing: 10, // Khoảng cách giữa các cột
                          mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                        ),
                        itemCount: orderList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailsScreens.routeName,
                                arguments: orderList![index],
                              );
                            },
                            child: SingleProduct(
                              image: orderList![index].products[0].images[0],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
  }
}
