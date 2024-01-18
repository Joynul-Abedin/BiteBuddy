import 'package:bite_buddy/Views/User/Cart/Provider/CartProvider.dart';
import 'package:bite_buddy/Views/User/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utility/Utility.dart';
import 'Cart/CartPage.dart';
import 'Profile/ProfilePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorUtils.primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: ColorUtils.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                Positioned(
                  right: 0,
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return cart.itemCount > 0
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                cart.itemCount.toString(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: ColorUtils.primaryColor,
          ),
        ],
        currentIndex: _selectedIndex,
        // Set the currentIndex
        selectedItemColor: ColorUtils.secondaryColor,
        unselectedItemColor: ColorUtils.secondaryColor,
        onTap: _onItemTapped, // Set the onTap callback
      ),
      body: _buildBody(), // Call a method to build body based on selected index
    );
  }

// Method to return different widgets based on selected index
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage(); // Build home widget
      case 1:
        return const CartPage(); // Placeholder for cart widget
      case 2:
        return const ProfilePage(); // Placeholder for profile widget
      default:
        return const HomePage(); // Default to home widget
    }
  }
}
