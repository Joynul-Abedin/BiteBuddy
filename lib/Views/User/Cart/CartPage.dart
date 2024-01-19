import 'package:bite_buddy/Model/FooItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utility/Utility.dart';
import '../CheckOut/CheckOutPage.dart';
import 'Provider/CartProvider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final aggregatedItems = _aggregateCartItems(cart.cartItems);
        final totalAmount = _calculateTotalAmount(aggregatedItems);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Cart',
              style: TextStyle(color: ColorUtils.secondaryColor, fontSize: 20),
            ),
            backgroundColor: ColorUtils.primaryColor,
            iconTheme: IconThemeData(color: ColorUtils.secondaryColor),
          ),
          body: Container(
            color: ColorUtils.primaryColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: aggregatedItems.length,
                    itemBuilder: (context, index) {
                      final item = aggregatedItems[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.pictureUrl),
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(color: ColorUtils.secondaryColor, fontSize: 18),
                        ),
                        subtitle: Text(
                          'Quantity: ${item.quantity}',
                          style: TextStyle(color: ColorUtils.secondaryColor, fontSize: 16),
                        ),
                        trailing: Text(
                          '৳ ${(item.price * item.quantity).toStringAsFixed(2)} TK',
                          style: TextStyle(color: ColorUtils.secondaryColor, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: ColorUtils.secondaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, color: ColorUtils.secondaryColor, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '৳ ${totalAmount.toStringAsFixed(2)} TK',
                        style: TextStyle(fontSize: 20, color: ColorUtils.secondaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: ColorUtils.primaryColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  double _calculateTotalAmount(List<FoodItem> items) {
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Aggregates similar items in the cart by summing up their quantities
  List<FoodItem> _aggregateCartItems(List<FoodItem> items) {
    Map<String, FoodItem> aggregatedItems = {};

    for (var item in items) {
      if (aggregatedItems.containsKey(item.id)) {
        var aggregatedItem = aggregatedItems[item.id]!;
        aggregatedItem.quantity += 1;  // Increase the quantity by 1
        // aggregatedItem.price = item.price * aggregatedItem.quantity; // Update the total price
      } else {
        // Add a new item with the initial quantity set to 1
        aggregatedItems[item.id] = FoodItem(
          id: item.id,
          name: item.name,
          pictureUrl: item.pictureUrl,
          price: item.price,
          quantity: 1,
          description: item.description,
        );
      }
    }
    return aggregatedItems.values.toList();
  }
}
