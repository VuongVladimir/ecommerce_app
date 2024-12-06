import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/error_handling.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/models/sales.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/models/shop_stats.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/order.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/user.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SellerServices {
  Future<String> registerSeller({
    required BuildContext context,
    required String shopName,
    required String shopDescription,
    required File avatar,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String status = '';
    try {
      // Upload avatar to cloudinary
      final cloudinary = CloudinaryPublic('dvgeq2l6e', 'xuvwiao4');
      CloudinaryResponse avatarRes = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(avatar.path, folder: shopName),
      );
      
      http.Response res = await http.post(
        Uri.parse('$uri/api/register-seller'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'shopName': shopName,
          'shopDescription': shopDescription,
          'avatarUrl': avatarRes.secureUrl,
        }),
      );
      
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          status = jsonDecode(res.body)['status'];
          showSnackBar(
            context,
            'Seller registration request sent successfully!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return status;
  }

  Future<String> checkRequestStatus(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String status = '';
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/seller-request-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          status = jsonDecode(res.body)['status'];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return status;
  }

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
    required String sellerId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      // ko luu anh tren mongodb vi dung luong kha it(shared clutter),luu anh tren cloudinary
      final cloudinary = CloudinaryPublic('dvgeq2l6e', 'xuvwiao4');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
        sellerId: sellerId,
      );
      http.Response res = await http.post(
        Uri.parse('$uri/seller/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product added successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/seller/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/seller/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/seller/get-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/seller/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    double totalEarnings = 0;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/seller/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarnings = response['totalEarnings'].toDouble();
          sales = (response['categoryData'] as List)
              .map((data) => Sales.fromMap(data))
              .toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarnings,
    };
  }

  // Update Product
  void updateProduct({
    required BuildContext context,
    required Product product,
    required List<String> images,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<File> newImages,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      List<String> newImageUrls = [];
      if (newImages.isNotEmpty) {
        // ko luu anh tren mongodb vi dung luong kha it(shared clutter),luu anh tren cloudinary
        final cloudinary = CloudinaryPublic('dvgeq2l6e', 'xuvwiao4');

        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(newImages[i].path, folder: name),
          );
          newImageUrls.add(res.secureUrl);
        }
      }
      List<String> updateImages =
          (newImageUrls.isNotEmpty) ? newImageUrls : images;
      http.Response res = await http.post(
        Uri.parse('$uri/seller/update-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
          'name': name,
          'description': description,
          'price': price,
          'quantity': quantity,
          'category': category,
          'images': updateImages,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product updated successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getShopData(BuildContext context, String sellerId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  User? shopOwner;
  List<Product> products = [];
  
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/seller/shop-data/$sellerId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        var data = jsonDecode(res.body);
        shopOwner = User.fromMap(data['shopOwner']);
        products = (data['products'] as List)
            .map((product) => Product.fromJson(jsonEncode(product)))
            .toList();
      },
    );
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return {
    'shopOwner': shopOwner,
    'products': products,
  };
}

// Update getShopStats to accept sellerId
Future<ShopStats> getShopStats(BuildContext context, String sellerId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  ShopStats stats = ShopStats(totalProducts: 0, avgRating: 0, followerCount: 0);
  
  try {
    http.Response res = await http.get(
      Uri.parse('$uri/seller/shop-stats/$sellerId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        stats = ShopStats.fromJson(jsonDecode(res.body));
      },
    );
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return stats;
}


// The follow/unfollow methods look good, but let's update the user provider after success
Future<void> followSeller({
  required BuildContext context,
  required String sellerId,
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/seller/follow'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'sellerId': sellerId,
      }),
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        userProvider.followSeller(sellerId);
        showSnackBar(context, 'Successfully followed seller');
      },
    );
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}

Future<void> unfollowSeller({
  required BuildContext context,
  required String sellerId,
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    http.Response res = await http.post(
      Uri.parse('$uri/seller/unfollow'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'sellerId': sellerId,
      }),
    );

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        userProvider.unfollowSeller(sellerId);
        showSnackBar(context, 'Successfully unfollowed seller');
      },
    );
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}

}
