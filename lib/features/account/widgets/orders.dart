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
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Your Orders',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      'See all',
                      style:
                          TextStyle(color: GlobalVariables.selectedNavBarColor),
                    ),
                  ),
                ],
              ),
              // Thay thế Container cũ bằng Expanded và GridView
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
