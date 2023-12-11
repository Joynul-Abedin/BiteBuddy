import 'package:flutter/cupertino.dart';

class FoodItem {
  String id;
  String name;
  String pictureUrl;
  double price;
  int quantity;
  String description;

  FoodItem({
    required this.id,
    required this.name,
    required this.pictureUrl,
    required this.price,
    required this.quantity,
    required this.description,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return FoodItem(
      id: json['_id'],
      name: json['name'],
      pictureUrl: json['pictureUrl'],
      price: json['price'].toDouble(), // Ensures price is a double
      quantity: json['quantity'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pictureUrl': pictureUrl,
      'price': price,
      'quantity': quantity,
      'description': description,
    };
  }
}
