import 'dart:convert';

import 'package:bite_buddy/Model/FooItem.dart';
import 'package:bite_buddy/Views/Admin/Components/DetailsFoodView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../Utility/Constants.dart';
import '../../../Utility/SharedPreference.dart';
import '../../../Utility/Utility.dart';

class FoodItemView extends StatefulWidget {
  final FoodItem foodItem;

  const FoodItemView({Key? key, required this.foodItem}) : super(key: key);

  @override
  State<FoodItemView> createState() => _FoodItemViewState();
}

class _FoodItemViewState extends State<FoodItemView> {
// Controllers for text fields
  TextEditingController nameController = TextEditingController();

  TextEditingController pictureUrlController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.foodItem.name;
    pictureUrlController.text = widget.foodItem.pictureUrl;
    priceController.text = widget.foodItem.price.toString();
    quantityController.text = widget.foodItem.quantity.toString();
    descriptionController.text = widget.foodItem.description;
  }

  @override
  Widget build(BuildContext context) {
    final userType =
        UserPreferences().getStringValue(Constants.USER_TYPE, 'user');
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailsFoodView(foodItem: widget.foodItem);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: ColorUtils.secondaryColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.width / 2.9,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.foodItem.pictureUrl,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3, // Giving twice the space for the name
                        child: Text(
                          widget.foodItem.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.secondaryTextColor,
                            fontFamily: FontUtility.primaryTextFont,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                        ),
                      ),
                      Flexible(
                        flex: 2, // Assigning less space for the price
                        child: Text(
                          "Tk${widget.foodItem.price.toString()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorUtils.secondaryTextColor,
                            fontFamily: FontUtility.primaryTextFont,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (userType == 'owner')
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () => _showPopupMenu(context),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        )
    ]);
  }

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context); // Close the pop-up
                _openEditDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the pop-up
                _confirmDelete(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Calculate the width
        double dialogWidth = MediaQuery.of(context).size.width - 20;
        return AlertDialog(
          content: Container(
            width: dialogWidth,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                    child: const Text('Update Item'),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          pictureUrlController.text.isNotEmpty &&
                          priceController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty) {
                        var response = await http.put(
                          Uri.parse(
                              '${Constants.baseUrl}/food-item/${widget.foodItem.id}'),
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
                        debugPrint(widget.foodItem.id);
                        debugPrint(response.body);
                        debugPrint(response.statusCode.toString());
                        if (response.statusCode == 200) {
                          debugPrint('Food item added successfully');
                        } else {
                          debugPrint('Failed to add food item');
                        }
                        Navigator.pop(context);
                      } else {
                        debugPrint('Validation failed');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFoodItem();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFoodItem() async {
    String itemId = widget.foodItem.id;
    var url = Uri.parse('${Constants.baseUrl}/food-item/$itemId');
    debugPrint('Deleting item at URL: $url');

    try {
      var response = await http.delete(url);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Food item deleted successfully');
        // Update your UI accordingly
        Fluttertoast.showToast(
          msg: 'Food item deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        debugPrint(
            'Failed to delete food item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting food item: $e');
    }
  }
}
