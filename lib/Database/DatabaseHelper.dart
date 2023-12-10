import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "BiteBuddy.db";
  static const _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  // Open the database and create it if it doesn't exist.
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE categories (
            idCategory TEXT PRIMARY KEY,
            strCategory TEXT,
            strCategoryThumb TEXT,
            strCategoryDescription TEXT
          )
          ''');
    // Add other tables (meals, mealDetails) creation logic here.

    await db.execute('''
          CREATE TABLE meals (
            idMeal TEXT PRIMARY KEY,
            strMeal TEXT,
            strMealThumb TEXT,
            idCategory TEXT,
            FOREIGN KEY (idCategory) REFERENCES categories (idCategory)
          )
          ''');

    await db.execute('''
          CREATE TABLE mealDetails (
            idMeal TEXT PRIMARY KEY,
            strMeal TEXT,
            strDrinkAlternate TEXT,
            idCategory TEXT,
            strCategory TEXT,
            strArea TEXT,
            strInstructions TEXT,
            strMealThumb TEXT,
            strTags TEXT,
            strYoutube TEXT,
            strSource TEXT,
            strIngredient1 TEXT,
            strIngredient2 TEXT,
            strIngredient3 TEXT,
            strIngredient4 TEXT,
            strIngredient5 TEXT,
            strIngredient6 TEXT,
            strIngredient7 TEXT,
            strIngredient8 TEXT,
            strIngredient9 TEXT,
            strIngredient10 TEXT,
            strIngredient11 TEXT,
            strIngredient12 TEXT,
            strIngredient13 TEXT,
            strIngredient14 TEXT,
            strIngredient15 TEXT,
            strIngredient16 TEXT,
            strIngredient17 TEXT,
            strIngredient18 TEXT,
            strIngredient19 TEXT,
            strIngredient20 TEXT,
            strMeasure1 TEXT,
            strMeasure2 TEXT,
            strMeasure3 TEXT,
            strMeasure4 TEXT,
            strMeasure5 TEXT,
            strMeasure6 TEXT,
            strMeasure7 TEXT,
            strMeasure8 TEXT,
            strMeasure9 TEXT,
            strMeasure10 TEXT,
            strMeasure11 TEXT,
            strMeasure12 TEXT,
            strMeasure13 TEXT,
            strMeasure14 TEXT,
            strMeasure15 TEXT,
            strMeasure16 TEXT,
            strMeasure17 TEXT,
            strMeasure18 TEXT,
            strMeasure19 TEXT,
            strMeasure20 TEXT,
            FOREIGN KEY (idCategory) REFERENCES categories (idCategory)
          )
          ''');
  }

// Helper methods for CRUD operations...

  Future<int> insertCategory(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('categories', row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> inserAllCategory(List<Map<String, dynamic>> rows) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    rows.forEach((row) {
      batch.insert('categories', row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    await batch.commit();
  }

  Future<int> insertMeal(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('meals', row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> inserAllMeal(List<Map<String, dynamic>> rows) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    rows.forEach((row) {
      batch.insert('meals', row, conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    await batch.commit();
  }

  Future<int> insertMealDetails(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('mealDetails', row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> inserAllMealDetails(List<Map<String, dynamic>> rows) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    rows.forEach((row) {
      batch.insert('mealDetails', row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> queryAllCategories() async {
    Database db = await instance.database;
    return await db.query('categories');
  }

  Future<List<Map<String, dynamic>>> queryAllMeals() async {
    Database db = await instance.database;
    return await db.query('meals');
  }

  Future<List<Map<String, dynamic>>> queryAllMealWithCategoryId(
      String categoryId) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT meals.idMeal, meals.strMeal, meals.strMealThumb, meals.idCategory, categories.strCategory
    FROM meals
    INNER JOIN categories ON meals.idCategory = categories.idCategory
    WHERE categories.idCategory = ?
  ''', [categoryId]);
  }

  Future<List<Map<String, dynamic>>> queryAllMealDetails() async {
    Database db = await instance.database;
    return await db.query('mealDetails');
  }

  Future<List<Map<String, dynamic>>> queryCategory(String idCategory) async {
    Database db = await instance.database;
    return await db
        .query('categories', where: 'idCategory = ?', whereArgs: [idCategory]);
  }

  Future<List<Map<String, dynamic>>> queryMeal(String idMeal) async {
    Database db = await instance.database;
    return await db.query('meals', where: 'idMeal = ?', whereArgs: [idMeal]);
  }

  Future<List<Map<String, dynamic>>> queryMealDetails(String idMeal) async {
    Database db = await instance.database;
    return await db
        .query('mealDetails', where: 'idMeal = ?', whereArgs: [idMeal]);
  }

  Future<int> deleteCategory(String idCategory) async {
    Database db = await instance.database;
    return await db
        .delete('categories', where: 'idCategory = ?', whereArgs: [idCategory]);
  }

  Future<int> deleteMeal(String idMeal) async {
    Database db = await instance.database;
    return await db.delete('meals', where: 'idMeal = ?', whereArgs: [idMeal]);
  }

  Future<int> deleteMealDetails(String idMeal) async {
    Database db = await instance.database;
    return await db
        .delete('mealDetails', where: 'idMeal = ?', whereArgs: [idMeal]);
  }

  Future<int> updateCategory(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String idCategory = row['idCategory'];
    return await db.update('categories', row,
        where: 'idCategory = ?', whereArgs: [idCategory]);
  }
}
