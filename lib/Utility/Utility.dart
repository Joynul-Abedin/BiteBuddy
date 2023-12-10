import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utility{
  static const Categories = "https://www.themealdb.com/api/json/v1/1/categories.php";
  static const Filter = "https://www.themealdb.com/api/json/v1/1/filter.php?c={strCategory}";
  static const DetailRecipe = "https://www.themealdb.com/api/json/v1/1/lookup.php?i={idMeal}";
}

class ColorUtils{
  static final primaryColor = Colors.indigo[500];
  static final primaryTextColor = Colors.indigo[200];
  static final secondaryColor = Colors.indigo[100];
  static final secondaryTextColor = Colors.indigo[900];
}

class FontUtility{
  static final primaryTextFont = GoogleFonts.poiretOne().fontFamily;
}