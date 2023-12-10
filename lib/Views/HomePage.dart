import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import '../Database/DatabaseHelper.dart';
import '../Google Ads/BannerAds.dart';
import '../Model/Category.dart';
import '../Utility/AddUtility.dart';
import '../Utility/Utility.dart';
import 'Components/CategoryItem.dart';
import 'Components/SearchBarWithSettingsButton.dart';

class RecipeHelper extends StatefulWidget {
  const RecipeHelper({super.key});

  @override
  State<RecipeHelper> createState() => _RecipeHelperState();
}

class _RecipeHelperState extends State<RecipeHelper> {
  late Future<List<Category>> categories;
  BannerAd banner = AddUtility().myBanner;

  Future<List<Category>> fetchCategories() async {
    // First, try to load from the local database
    List<Category> localCategories = await getCategories();

    if (localCategories.isNotEmpty) {
      debugPrint("Categories from local database");
      return localCategories; // Return local data if available
    }

    // If not available locally, fetch from the API
    final response = await http.get(Uri.parse(Utility.Categories));

    if (response.statusCode == 200) {
      List categoriesJson = json.decode(response.body)['categories'];
      List<Category> categories =
          categoriesJson.map((json) => Category.fromJson(json)).toList();

      // Convert categories to a list of maps
      List<Map<String, dynamic>> categoryMaps =
          categories.map((category) => category.toMap()).toList();

      // Insert all categories into the local database
      await DatabaseHelper.instance.inserAllCategory(categoryMaps);
      List<Category> localCategoriesAfterInsert = await getCategories();
      return localCategoriesAfterInsert;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Category>> getCategories() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> maps = await db.queryAllCategories();

    if (maps.isNotEmpty) {
      return maps.map((map) => Category.fromJson(map)).toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    banner.load();
    categories = fetchCategories();
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
                child: FutureBuilder<List<Category>>(
                  future: categories,
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
                          return CategoryItem(category: snapshot.data![index]);
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
