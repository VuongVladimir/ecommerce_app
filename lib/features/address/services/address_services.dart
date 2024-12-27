import 'dart:convert';

import 'package:ecommerce_app_fluterr_nodejs/constants/error_handling.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/order_details/screens/order_details_screens.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/order.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/user.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // order product
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
    required List<int> selectedItems,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final selectedCart =
          selectedItems.map((index) => userProvider.user.cart[index]).toList();
      http.Response res = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'cart': selectedCart,
          'totalPrice': totalSum,
          'address': address,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Your order has been placed!");
          final updatedCart = List.from(userProvider.user.cart);
          // Sắp xếp selectedItems giảm dần để xóa từ cuối lên để không ảnh hưởng index
          final sortedIndexes = selectedItems.toList()
            ..sort((a, b) => b.compareTo(a));
          for (var index in sortedIndexes) {
            updatedCart.removeAt(index);
          }

          // Cập nhật UserProvider với cart mới
          User user = userProvider.user.copyWith(
            cart: updatedCart,
          );
          userProvider.setUserFromModel(user);
          Navigator.pushReplacementNamed(
            context,
            OrderDetailsScreens.routeName,
            arguments: Order.fromJson(res.body),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void placeDirectOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
    required List<Product> products,
    required List<int> quantities,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/order-direct'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'products': products.map((e) => e.toMap()).toList(),
          'quantities': quantities,
          'totalPrice': totalSum,
          'address': address,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Your order has been placed!");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String> getSellerAddress({
    required BuildContext context,
    required String sellerId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String address = '';

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/seller/address/$sellerId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          address = jsonDecode(res.body)['address'];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return address;
  }

  Future<List<String>> getSellerAddresses(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<String> addresses = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/seller/addresses/cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          addresses = List<String>.from(jsonDecode(res.body));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return addresses;
  }
}
