import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  Timer? _discountTimer;

  List<Product> get products => _products;

  void setProducts(List<Product> products) {
    _products = products;
    _startDiscountTimer();
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void _startDiscountTimer() {
    _discountTimer?.cancel();
    _discountTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      bool updated = false;
      final now = DateTime.now();
      
      for (var product in _products) {
        if (product.discount != null) {
          if (now.isAfter(product.discount!.endDate!)) {
            product = Product(
              id: product.id,
              name: product.name,
              description: product.description,
              quantity: product.quantity,
              images: product.images,
              category: product.category,
              price: product.price,
              sellerId: product.sellerId,
              discount: null,
              finalPrice: product.price,
            );
            updated = true;
          }
        }
      }
      
      if (updated) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _discountTimer?.cancel();
    super.dispose();
  }
}