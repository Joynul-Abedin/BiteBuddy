import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/CartItem.dart';
import 'Provider/CartProvider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Example cart items list
  List<CartItem> cartItems = [
    CartItem(id: '1', name: 'Apple', price: 0.99, quantity: 2),
    CartItem(id: '2', name: 'Bread', price: 2.49, quantity: 1),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        // Build your UI based on CartModel here
        return Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
          ),
          body: ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: (context, index) {
              final item = cart.cartItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Text('\$${item.price}'),
              );
            },
          ),
        );
      },
    );
  }
}
