import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import '../../../Database/DatabaseHelper.dart';
import '../../../Google Ads/BannerAds.dart';
import '../../../Model/Category.dart';
import '../../../Model/Meal.dart';
import '../../../Utility/AddUtility.dart';
import '../../../Utility/Utility.dart';
import 'MealItem.dart';

class CategoryWiseFoodList extends StatefulWidget {
  final Category category;
  const CategoryWiseFoodList({super.key, required this.category});

  @override
  State<CategoryWiseFoodList> createState() => _CategoryWiseFoodListState();
}

class _CategoryWiseFoodListState extends State<CategoryWiseFoodList> {
  late Future<List<Meal>> meals;
  BannerAd banner = AddUtility().myBanner;
  Future<List<Meal>> fetchMealsByCategory(
      String category, String categoryId) async {
    List<Meal> localMeals = await getMealsByCategory(categoryId);

    if (localMeals.isNotEmpty) {
      debugPrint("Meals from local database");
      return localMeals;
    }
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> mealsJson = jsonResponse['meals'];
      List<Meal> meals = mealsJson.map<Meal>((json) {
        return Meal.fromJson(json)..idCategory = categoryId;
      }).toList();
      List<Map<String, dynamic>> mealsMap =
          meals.map((meal) => meal.toMap()).toList();
      await DatabaseHelper.instance.inserAllMeal(mealsMap);
      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<Meal>> getMealsByCategory(String categoryId) async {
    DatabaseHelper db = DatabaseHelper.instance;

    List<Map<String, dynamic>> maps =
        await db.queryAllMealWithCategoryId(categoryId);
    if (maps.isNotEmpty) {
      return maps.map((map) => Meal.fromJson(map)).toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    banner.load();
    meals = fetchMealsByCategory(
        widget.category.strCategory, widget.category.idCategory);
  }

  String formatText(String text) {
    RegExp exp = RegExp(r'\[\d+\]');
    return text.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      appBar: AppBar(
          title: Text("Food List of ${widget.category.strCategory}",
              style: TextStyle(
                color: ColorUtils.secondaryColor,
                fontFamily: FontUtility.primaryTextFont,
              )),
          backgroundColor: ColorUtils.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Platform.isAndroid
                ? Icon(
                    Icons.arrow_back,
                    color: ColorUtils.secondaryColor,
                  )
                : Icon(
                    Icons.arrow_back_ios_new,
                    color: ColorUtils.secondaryColor,
                  ),
            onPressed: () => Navigator.pop(context),
          )),
      body: Container(
        color: ColorUtils.primaryColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.category.strCategoryThumb),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: ColorUtils.secondaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.primaryColor!,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Hero(
                              tag:
                                  'categoryHero${widget.category.idCategory}', // Unique Hero tag
                              child: Image.network(
                                widget.category.strCategoryThumb,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                formatText(
                                    widget.category.strCategoryDescription),
                                style: TextStyle(
                                  color: ColorUtils.secondaryColor,
                                  fontFamily: FontUtility.primaryTextFont,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: Text("Food List",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.secondaryColor,
                            fontFamily: FontUtility.primaryTextFont,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Meal>>(
                  future: meals,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return GridView.count(
                        padding: const EdgeInsets.all(0),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(snapshot.data!.length, (index) {
                          final meal = snapshot.data![index];
                          return MealItem(meal: meal);
                        }),
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(child: Text('No meals found')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BannerAdWidget(
        myBanner: banner,
      ),
    );
  }
}
