import 'package:ecommerce_app_fluterr_nodejs/common/widgets/bottom_bar.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/address/screens/address_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/cart/widgets/cart_product.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/cart/widgets/cart_subtotal.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/home/widgets/address_box.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/search/screens/search_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Set<int> _selectedItems = {};
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddressScreen(double sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: {
        'totalAmount': sum.toStringAsFixed(2),
        'selectedItems': _selectedItems.toList(),
      },
    );
  }

  double calculateSelectedTotal(List<dynamic> cart) {
    double sum = 0;
    for (int index in _selectedItems) {
      if (index < cart.length) {
        var item = cart[index];
        double price =
            (item['product']['finalPrice'] ?? item['product']['price'])
                .toDouble();
        int quantity = item['quantity'] as int;
        sum += price * quantity;
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double selectedTotal = calculateSelectedTotal(user.cart);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 3,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search in Revos',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: user.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 120,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Cart is Empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Looks like you haven\'t added anything to your cart yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Start Shopping",
                      textColor: Colors.black,
                      function: () {
                        Navigator.pushReplacementNamed(
                            context, BottomBar.routeName);
                      },
                      color: Colors.yellow[600],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const AddressBox(),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _selectedItems.length == user.cart.length,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedItems.clear();
                                _selectedItems.addAll(
                                    List.generate(user.cart.length, (i) => i));
                              } else {
                                _selectedItems.clear();
                              }
                            });
                          },
                        ),
                        const Text(
                          'Select All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: user.cart.length,
                      itemBuilder: (context, index) {
                        return CartProduct(
                          index: index,
                          isSelected: _selectedItems.contains(index),
                          onSelected: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedItems.add(index);
                              } else {
                                _selectedItems.remove(index);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.black12.withOpacity(0.08),
                    height: 1,
                  ),
                  Container(height: 5),
                  CartSubtotal(selectedTotal: selectedTotal),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Proceed to Buy (${_selectedItems.length} items)",
                      function: _selectedItems.isEmpty
                          ? null
                          : () => navigateToAddressScreen(selectedTotal),
                      color: Colors.yellow[600],
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
