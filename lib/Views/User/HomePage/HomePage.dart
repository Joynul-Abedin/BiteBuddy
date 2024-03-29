import 'dart:async';
import 'dart:convert';

import 'package:bite_buddy/Model/User.dart';
import 'package:bite_buddy/Views/Common%20Components/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Model/Category.dart';
import '../../../Model/FooItem.dart';
import '../../../Utility/Constants.dart';
import '../../../Utility/SharedPreference.dart';
import '../../../Utility/Utility.dart';
import '../../Admin/Components/FoodItemView.dart';
import '../Components/SearchBarWithSettingsButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer dataFetchTimer;
  User? user;

  late Future<List<Category>> categories;

  // BannerAd banner = AddUtility().myBanner;
  late Future<List<FoodItem>> foodItems;

  final urls = [
    "https://movieinfo-3owl.onrender.com",
    "https://qrcode-generator-7o6r.onrender.com/ping",
    "https://bitebuddy-nydw.onrender.com/api/v1/ping",
    "https://tree-info.onrender.com/api/species/ping",
    "https://weathertogo.onrender.com/api/ping"
  ];

  Future<List<FoodItem>> fetchFoodItems() async {
    for (var url in urls) {
      var server = await http.get(Uri.parse(url));
      debugPrint('Server: ${server.statusCode}');
    }

    var response = await http
        .get(Uri.parse('https://bitebuddy-nydw.onrender.com/api/v1/food-item'));

    if (response.statusCode == 200) {
      List foodItemJson = json.decode(response.body);
      List<FoodItem> foodItem =
          foodItemJson.map((json) => FoodItem.fromJson(json)).toList();
      return foodItem;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<User> getUserWithEmail() async {
    final email = UserPreferences().getStringValue(Constants.USER_EMAIL, '');
    debugPrint('Email: $email');
    var server = await http.get(Uri.parse('https://serverrefresher-shokal07.pythonanywhere.com/'));
    debugPrint('Server: ${server.statusCode}');
    var response = await http.get(Uri.parse('https://bitebuddy-nydw.onrender.com/api/v1/users/$email'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  startTimerDataFetch() {
    dataFetchTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        foodItems = fetchFoodItems();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    dataFetchTimer.cancel();
  }

  @override
  void initState() {
    super.initState();
    // banner.load();
    foodItems = fetchFoodItems();
    getUserWithEmail().then((fetchedUser) {
      setState(() {
        debugPrint('User fetched: ${fetchedUser.name}');
        user = fetchedUser;
      });
    });
    startTimerDataFetch();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: ColorUtils.primaryColor,
            appBar: AppBar(
              backgroundColor: ColorUtils.primaryColor,
            ),
            body: Container(
              color: ColorUtils.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Hello, Foodie!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontUtility.primaryTextFont,
                              color: ColorUtils.secondaryColor,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: ColorUtils.secondaryColor,
                                fontFamily: FontUtility.primaryTextFont,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Make your own Food \nstay at '),
                              TextSpan(
                                text: 'Home!',
                                style: TextStyle(
                                    fontFamily: FontUtility.primaryTextFont,
                                    color: Colors
                                        .amber), // Change this color as needed
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SearchBarWithSettingsButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 8.0, bottom: 8.0),
                          child: Text("Categories",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: ColorUtils.secondaryColor,
                                  fontFamily: FontUtility.primaryTextFont,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<List<FoodItem>>(
                        future: foodItems,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
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
                            return Text('${snapshot.error}');
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawer: DrawerWidget(
              user: user!,
            ));
  }
}
