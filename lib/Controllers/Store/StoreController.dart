import 'dart:io';

import 'package:flutter/cupertino.dart';

class StoreController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
  final List<String> menu = ['Category 1', 'Category 2', 'Category 3'];
  File? userImage;
  String? fileIdFromApi;

  String? selectedCategory;
  String? selectedMenu;
}