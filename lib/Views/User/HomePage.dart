import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import '../../Google Ads/BannerAds.dart';
import '../../Model/Category.dart';
import '../../Model/FooItem.dart';
import '../../Utility/AddUtility.dart';
import '../../Utility/Utility.dart';
import '../Admin/Components/FoodItemView.dart';
import 'Components/SearchBarWithSettingsButton.dart';

class RecipeHelper extends StatefulWidget {
  const RecipeHelper({super.key});

  @override
  State<RecipeHelper> createState() => _RecipeHelperState();
}

class _RecipeHelperState extends State<RecipeHelper> {
  late Timer dataFetchTimer;
  late Future<List<Category>> categories;
  BannerAd banner = AddUtility().myBanner;
  late Future<List<FoodItem>> foodItems;

  Future<List<FoodItem>> fetchFoodItems() async {
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

  startTimerDataFetch() {
    dataFetchTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        foodItems = fetchFoodItems();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dataFetchTimer.cancel();
  }

  @override
  void initState() {
    super.initState();
    banner.load();
    foodItems = fetchFoodItems();
    startTimerDataFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      body: Container(
        color: ColorUtils.primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 10, right: 10),
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
                        const TextSpan(text: 'Make your own Food \nstay at '),
                        TextSpan(
                          text: 'Home!',
                          style: TextStyle(
                              fontFamily: FontUtility.primaryTextFont,
                              color:
                                  Colors.amber), // Change this color as needed
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
                          return FoodItemView(foodItem: snapshot.data![index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BannerAdWidget(
        myBanner: banner,
      ),
    );
  }
}
