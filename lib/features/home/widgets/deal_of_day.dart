import 'package:ecommerce_app_fluterr_nodejs/features/home/services/home_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/product_details/screens/product_details_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  final HomeServices homeServices = HomeServices();
  List<Product>? productList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDealOfDay();
  }

  void getDealOfDay() async {
    productList = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return productList == null
        ? const Center(child: CircularProgressIndicator())
        : productList!.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: const Text(
                      'Deal of the day',aaaaaaaa
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductDetailsScreen.routeName,
                        arguments: productList![0],
                      );
                    },
                    child: Image.network(
                      productList![0].images[0],
                      height: 235,
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      '\$999',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 40),
                    child: const Text(
                      'Iphone',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: productList!
                          .map(
                            (i) => InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProductDetailsScreen.routeName,
                                  arguments: i,
                                );
                              },
                              child: Image.network(i.images[0],
                                  fit: BoxFit.fitWidth,
                                  width: 150,
                                  height: 150),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'See all deals',
                      style: TextStyle(color: Colors.cyan[800]),
                    ),
                  ),
                ],
              );
  }
}
