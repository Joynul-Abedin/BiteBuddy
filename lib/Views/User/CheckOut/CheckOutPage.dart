import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/FooItem.dart';
import '../../../Utility/Utility.dart';
import '../Cart/Provider/CartProvider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  String? _selectedCheckoutOption;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final aggregatedItems = _aggregateCartItems(cartProvider.cartItems);
    final totalAmount = _calculateTotalAmount(aggregatedItems);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: ColorUtils.secondaryColor)),
        backgroundColor: ColorUtils.primaryColor,
      ),
      body: Container(
        color: ColorUtils.primaryColor,
        child: Column(
          children: [
            _buildCheckoutOptions(),
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
              onPressed: _selectedCheckoutOption != null ? () {
                // Proceed with the selected checkout option
              } : null,
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutOptions() {
    List<String> checkoutOptions = ['Credit Card', 'PayPal', 'Cash on Delivery'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select a payment method:', style: TextStyle(fontSize: 18, color: ColorUtils.secondaryColor)),
          ...checkoutOptions.map((option) => RadioListTile<String>(
            title: Text(option, style: TextStyle(color: ColorUtils.secondaryColor)),
            value: option,
            groupValue: _selectedCheckoutOption,
            onChanged: (value) {
              setState(() {
                _selectedCheckoutOption = value;
              });
            },
            activeColor: Colors.green,
          )),
        ],
      ),
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


  double _calculateTotal(List<FoodItem> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price;
    }
    return total;
  }
}
