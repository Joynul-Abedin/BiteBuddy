import 'dart:convert';
import 'dart:io';

import 'package:bite_buddy/Utility/Constants.dart';
import 'package:bite_buddy/Utility/SharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../Model/Store.dart';

class StoreController {
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

  final TextEditingController mondayOpenController = TextEditingController();
  final TextEditingController mondayCloseController = TextEditingController();
  final TextEditingController tuesdayOpenController = TextEditingController();
  final TextEditingController tuesdayCloseController = TextEditingController();
  final TextEditingController wednesdayOpenController = TextEditingController();
  final TextEditingController wednesdayCloseController =
      TextEditingController();
  final TextEditingController thursdayOpenController = TextEditingController();
  final TextEditingController thursdayCloseController = TextEditingController();
  final TextEditingController fridayOpenController = TextEditingController();
  final TextEditingController fridayCloseController = TextEditingController();
  final TextEditingController saturdayOpenController = TextEditingController();
  final TextEditingController saturdayCloseController = TextEditingController();
  final TextEditingController sundayOpenController = TextEditingController();
  final TextEditingController sundayCloseController = TextEditingController();

  final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
  final List<String> menu = ['Category 1', 'Category 2', 'Category 3'];
  File? userImage;
  String? fileIdFromApi;
  String? selectedCategory;
  String? selectedMenu;

  Hours getHours() {
    return Hours(
      monday: OpenClose(
          open: mondayOpenController.text, close: mondayCloseController.text),
      tuesday: OpenClose(
          open: tuesdayOpenController.text, close: tuesdayCloseController.text),
      wednesday: OpenClose(
          open: wednesdayOpenController.text,
          close: wednesdayCloseController.text),
      thursday: OpenClose(
          open: thursdayOpenController.text,
          close: thursdayCloseController.text),
      friday: OpenClose(
          open: fridayOpenController.text, close: fridayCloseController.text),
      saturday: OpenClose(
          open: saturdayOpenController.text,
          close: saturdayCloseController.text),
      sunday: OpenClose(
          open: sundayOpenController.text, close: sundayCloseController.text),
    );
  }

  void submitDataToServer() async {
    final ownerId = UserPreferences().getStringValue(Constants.USER_ID, "");
    try {
      // Create Address, Location, Contact, and Hours objects using the controller data
      Address address = Address(
        street: streetController.text,
        city: cityController.text,
        state: stateController.text,
        zipCode: zipCodeController.text,
        country: countryController.text,
      );

      Location location = Location(
        type: 'Point',
        coordinates: [0.0, 0.0],
      );

      Contact contact = Contact(
        phone: phoneController.text,
        email: emailController.text,
        website: websiteController.text,
      );

      Hours hours = getHours();

      // Create a Store object
      Store store = Store(
        name: nameController.text,
        address: address,
        location: location,
        owner: ownerId,
        contact: contact,
        description: descriptionController.text,
        categories: selectedCategory.toString().split(','),
        menu: selectedMenu.toString().split(','),
        hours: hours,
        ratings: [],
        images: [userImage.toString()],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Convert Store object to JSON
      Map<String, dynamic> storeData = store.toJson();

      // Send the data to the server
      String url = '${Constants.baseUrl}/stores';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${UserPreferences().getStringValue(Constants.TOKEN, "")}',
        },
        body: json.encode(storeData),
      );

      debugPrint('Response: ${response.body}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Store data submitted successfully');
      } else {
        // Handle server error
        print('Failed to submit store data: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error submitting store data: $e');
    }
  }
}
