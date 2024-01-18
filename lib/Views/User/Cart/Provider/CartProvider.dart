import 'package:flutter/material.dart';

import '../../../../Model/FooItem.dart';

class CartProvider with ChangeNotifier {
  final List<FoodItem> _cartItems = [];

  List<FoodItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  void addToCart(FoodItem meal) {
    _cartItems.add(meal);
    notifyListeners();
  }
}
