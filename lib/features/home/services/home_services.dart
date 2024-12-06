import 'dart:convert';

import 'package:ecommerce_app_fluterr_nodejs/constants/error_handling.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var jsonData = jsonDecode(res.body) as List;
          productList = jsonData.map((item) {
            // Chuyển đổi sellerId từ Map thành các trường riêng lẻ
            if (item['sellerId'] != null && item['sellerId'] is Map) {
              item['shopName'] = item['sellerId']['shopName']?.toString() ?? '';
              item['shopAvatar'] = item['sellerId']['shopAvatar']?.toString() ?? '';
              item['sellerId'] = item['sellerId']['_id']?.toString() ?? '';
            }
            return Product.fromMap(item);
          }).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<List<Product>> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var jsonData = jsonDecode(res.body) as List;
          productList = jsonData.map((item) {
            // Chuyển đổi sellerId từ Map thành các trường riêng lẻ
            if (item['sellerId'] != null && item['sellerId'] is Map) {
              item['shopName'] = item['sellerId']['shopName']?.toString() ?? '';
              item['shopAvatar'] = item['sellerId']['shopAvatar']?.toString() ?? '';
              item['sellerId'] = item['sellerId']['_id']?.toString() ?? '';
            }
            return Product.fromMap(item);
          }).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}
