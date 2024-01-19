import 'dart:async';
import 'dart:convert';

import 'package:bite_buddy/Model/FooItem.dart';
import 'package:bite_buddy/Model/User.dart';
import 'package:bite_buddy/Utility/Utility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Utility/Constants.dart';
import '../../Utility/SharedPreference.dart';
import '../Common Components/Drawer.dart';
import 'Components/FoodItemView.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  late Timer dataFetchTimer;

  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController pictureUrlController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // List to hold your food items
  late Future<List<FoodItem>> foodItems;
  User? user;

  // Controller for the search field
  TextEditingController searchController = TextEditingController();

  Future<List<FoodItem>> fetchFoodItems([String? searchQuery]) async {
    var url = Uri.parse('${Constants.baseUrl}/food-item');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> foodItemJson = json.decode(response.body);

      // Filter items if a search query is provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        foodItemJson = foodItemJson.where((item) {
          return item['name'].toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }

      List<FoodItem> foodItems =
          foodItemJson.map((json) => FoodItem.fromJson(json)).toList();
      return foodItems;
    } else {
      throw Exception('Failed to load food items');
    }
  }

  void startTimerDataFetch() {
    dataFetchTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        foodItems = fetchFoodItems();
      });
    });
  }

  Future<User> getUserWithEmail() async {
    final email = UserPreferences().getStringValue(Constants.USER_EMAIL, '');
    debugPrint('Email: $email');
    var response = await http.get(
        Uri.parse('https://bitebuddy-nydw.onrender.com/api/v1/users/$email'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    dataFetchTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    foodItems = fetchFoodItems();
    getUserWithEmail().then((fetchedUser) {
      debugPrint('User fetched: ${fetchedUser.name}');
      setState(() {
        user = fetchedUser; // Update the user state when data is fetched
      });
    });
    // startTimerDataFetch();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Store Dashboard',
                style: TextStyle(color: ColorUtils.primaryTextColor),
              ),
              backgroundColor: ColorUtils.primaryColor,
              actions: [
                IconButton(
                  icon: Icon(Icons.add, color: ColorUtils.primaryTextColor),
                  onPressed: () => openAddFoodItemDialog(),
                ),
              ],
            ),
            body: Container(
              color: ColorUtils.primaryColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search Food Items',
                        labelStyle:
                            TextStyle(color: ColorUtils.primaryTextColor),
                        suffixIcon: Icon(Icons.search,
                            color: ColorUtils.primaryTextColor),
                      ),
                      onChanged: (value) {
                        if (dataFetchTimer.isActive) {
                          dataFetchTimer.cancel();
                        }

                        setState(() {
                          foodItems = fetchFoodItems(value);
                        });

                        if (value.isEmpty) {
                          startTimerDataFetch();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List<FoodItem>>(
                        future: foodItems,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            debugPrint('Data: ${snapshot.data?.length}');
                            return GridView.builder(
                              padding: const EdgeInsets.all(0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return FoodItemView(
                                    foodItem: snapshot.data![index]);
                              },
                            );
                          } else if (snapshot.hasError) {
                            debugPrint('Data: ${snapshot.data?.length}');
                            return Text('${snapshot.error}');
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            drawer: DrawerWidget(
              user: user!,
            ),
          );
  }

  void openAddFoodItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Calculate the width
        double dialogWidth = MediaQuery.of(context).size.width - 20;
        return AlertDialog(
          content: Container(
            width: dialogWidth,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: pictureUrlController,
                    decoration: const InputDecoration(labelText: 'Picture URL'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Add Item'),
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    pictureUrlController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  var response = await http.post(
                    Uri.parse('${Constants.baseUrl}/food-item'),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode({
                      'name': nameController.text,
                      'pictureUrl': pictureUrlController.text,
                      'price': double.parse(priceController.text),
                      'quantity': int.parse(quantityController.text),
                      'description': descriptionController.text,
                    }),
                  );
                  if (response.statusCode == 200) {
                    debugPrint('Food item added successfully');
                  } else {
                    debugPrint('Failed to add food item');
                  }
                  Navigator.pop(context);
                } else {
                  debugPrint('Validation failed');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
