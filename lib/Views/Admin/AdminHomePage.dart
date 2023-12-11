import 'dart:convert';

import 'package:bite_buddy/Model/FooItem.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'Components/FoodItemView.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController pictureUrlController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // List to hold your food items
  late Future<List<FoodItem>> foodItems;

  // Controller for the search field
  TextEditingController searchController = TextEditingController();

  Future<List<FoodItem>> fetchFoodItems() async {
    var response = await http.get(Uri.parse('https://bitebuddy-nydw.onrender.com/api/v1/food-item'));

    if (response.statusCode == 200) {
      List foodItemJson = json.decode(response.body);
      List<FoodItem> foodItem =
      foodItemJson.map((json) => FoodItem.fromJson(json)).toList();
      return foodItem;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodItems = fetchFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openAddFoodItemDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Food Items',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
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
                      return FoodItemView(foodItem: snapshot.data![index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  debugPrint('Data: ${snapshot.data?.length}');
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  void openAddFoodItemDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
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
              ElevatedButton(
                child: const Text('Add Item'),
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      pictureUrlController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      quantityController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    var response = await http.post(
                      Uri.parse('https://bitebuddy-nydw.onrender.com/api/v1/food-item'),
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
                      // Handle successful response
                      print('Food item added successfully');
                    } else {
                      // Handle error response
                      print('Failed to add food item');
                    }

                    Navigator.pop(context); // Close the bottom sheet
                  } else {
                    // Handle validation failure
                    print('Validation failed');
                  }
                },
              ),

            ],
          ),
        );
      },
    );
  }
}
