import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    for (var item in user.cart) {
      double price = (item['product']['finalPrice'] ?? item['product']['price'])
          .toDouble();
      int quantity = item['quantity'] as int;
      sum += price * quantity;
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal: ',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          Text(
            '\$${sum.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
