import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import '../../Database/DatabaseHelper.dart';
import '../../Google Ads/BannerAds.dart';
import '../../Model/Meal.dart';
import '../../Model/MealDetails.dart';
import '../../Utility/AddUtility.dart';
import '../../Utility/Utility.dart';

class MealDetailsPage extends StatefulWidget {
  final Meal meal;
  const MealDetailsPage({Key? key, required this.meal}) : super(key: key);
  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  late Future<MealDetails> mealDetails;

  BannerAd banner = AddUtility().myBanner;

  Future<MealDetails> fetchMealDetails(String mealId) async {
    MealDetails? localMealsDetails = await getMealDetails(mealId);
    if (localMealsDetails != null) {
      debugPrint("Meals from local database");
      return localMealsDetails;
    }
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final mealsJson = jsonResponse['meals'][0];
      MealDetails mealDetails = MealDetails.fromJson(mealsJson)
        ..idCategory = widget.meal.idCategory!;
      Map<String, dynamic> mealDetailsMap = mealDetails.toMap();
      await DatabaseHelper.instance.insertMealDetails(mealDetailsMap);
      return mealDetails;
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<MealDetails?> getMealDetails(String mealId) async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> maps = await db.queryMealDetails(mealId);

    if (maps.isNotEmpty) {
      return MealDetails.fromJson(maps.first);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    banner.load();
    mealDetails = fetchMealDetails(widget.meal.idMeal);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      appBar: AppBar(
        title: Text(
          widget.meal.strMeal,
          style: TextStyle(
            color: ColorUtils.secondaryColor,
            fontFamily: FontUtility.primaryTextFont,
          ),
        ),
        backgroundColor: ColorUtils.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Platform.isAndroid
              ? Icon(
                  Icons.arrow_back,
                  color: ColorUtils.secondaryColor,
                )
              : Icon(
                  Icons.arrow_back_ios,
                  color: ColorUtils.secondaryColor,
                ),
        ),
      ),
      body: Container(
        color: ColorUtils.primaryColor,
        child: SingleChildScrollView(
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: ColorUtils.secondaryColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: FutureBuilder<MealDetails>(
                      future: mealDetails,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: const Center(
                                  child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Center(
                                  child: Text('Error: ${snapshot.error}')));
                        } else if (snapshot.hasData) {
                          return buildMealDetailsContent(
                              snapshot.data!, screenWidth, screenHeight);
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: const Center(
                                child: Text('No meal details found')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 5.8,
              right: MediaQuery.of(context).size.width / 1.2,
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border_outlined,
                        size: 20,
                        color:
                            Colors.white), // You can adjust the size as needed
                    onPressed: () {
                      // The action you want to perform when the icon is tapped
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width / -5,
              child: Hero(
                tag: 'mealHero${widget.meal.idMeal}',
                transitionOnUserGestures: true,
                child: CircleAvatar(
                  radius: 130,
                  backgroundImage: NetworkImage(
                    widget.meal.strMealThumb,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: BannerAdWidget(
        myBanner: banner,
      ),
    );
  }

  Widget buildMealDetailsContent(
      MealDetails mealDetails, double screenWidth, double screenHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            "Ingredients:",
            style: TextStyle(
              fontSize: 18 * screenWidth / 400, // Adjust the value as needed
              fontWeight: FontWeight.bold,
              color: ColorUtils.secondaryTextColor,
              fontFamily: FontUtility.primaryTextFont,
            ),
          ),
          const SizedBox(height: 10),
          Table(
            columnWidths: {
              0: FixedColumnWidth(screenWidth * 0.42),
              1: FixedColumnWidth(screenWidth * 0.02),
              2: FixedColumnWidth(screenWidth * 0.46)
            },
            children: List<TableRow>.generate(
              mealDetails.ingredients.length,
              (index) {
                // Filter out empty or null ingredients
                if (mealDetails.ingredients[index]?.isNotEmpty ?? false) {
                  return TableRow(
                    children: [
                      Text(
                        mealDetails.ingredients[index] ?? '',
                        style: TextStyle(
                          fontSize: 14 * screenWidth / 400,
                          color: ColorUtils.secondaryTextColor,
                          fontFamily: FontUtility.primaryTextFont,
                        ),
                      ),
                      Text(":",
                          style: TextStyle(
                            color: ColorUtils.secondaryTextColor,
                            fontFamily: FontUtility.primaryTextFont,
                          )),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              mealDetails.measures[index]?.trim() ?? '',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14 * screenWidth / 400,
                                color: ColorUtils.secondaryTextColor,
                                fontFamily: FontUtility.primaryTextFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const TableRow(children: [
                  SizedBox(),
                  SizedBox(),
                  SizedBox()
                ]); // Empty table row for null/empty ingredients
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Instructions:",
            style: TextStyle(
              fontSize: 18 * screenWidth / 400,
              fontWeight: FontWeight.bold,
              color: ColorUtils.secondaryTextColor,
              fontFamily: FontUtility.primaryTextFont,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mealDetails.strInstructions.replaceAll(r'\r\n', '\n'),
            style: TextStyle(
              fontSize: 14 * screenWidth / 400,
              color: ColorUtils.secondaryTextColor,
              fontFamily: FontUtility.primaryTextFont,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
