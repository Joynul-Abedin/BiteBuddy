import 'dart:io';

import 'package:bite_buddy/Model/FooItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../Utility/AddUtility.dart';
import '../../../Utility/Utility.dart';
import '../../User/Cart/Provider/CartProvider.dart';

class DetailsFoodView extends StatefulWidget {
  final FoodItem foodItem;

  const DetailsFoodView({Key? key, required this.foodItem}) : super(key: key);

  @override
  State<DetailsFoodView> createState() => DetailsFoodViewState();
}

class DetailsFoodViewState extends State<DetailsFoodView> {
  BannerAd banner = AddUtility().myBanner;

  @override
  void initState() {
    super.initState();
    banner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      appBar: AppBar(
        title: Text(
          widget.foodItem.name,
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
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.foodItem.pictureUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: ColorUtils.secondaryColor,
                  ),
                  child: buildMealDetailsContent(widget.foodItem),
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Row(
                            children: [
                              Icon(Icons.add_shopping_cart),
                              Text("Add to Cart"),
                            ],
                          ),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(widget.foodItem);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Icon(Icons.favorite_border),
                              Text("Add to Favorite"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget buildMealDetailsContent(FoodItem foodItem) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                foodItem.name,
                style: TextStyle(
                  fontSize: 24 * screenWidth / 400,
                  // Adjust the value as needed
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.secondaryTextColor,
                  fontFamily: FontUtility.primaryTextFont,
                ),
              ),
              const Spacer(),
              Text(
                'from Tk ${foodItem.price}',
                style: TextStyle(
                  fontSize: 18 * screenWidth / 400,
                  // Adjust the value as needed
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.secondaryTextColor,
                  fontFamily: FontUtility.primaryTextFont,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Description:",
            style: TextStyle(
              fontSize: 18 * screenWidth / 400, // Adjust the value as needed
              fontWeight: FontWeight.bold,
              color: ColorUtils.secondaryTextColor,
              fontFamily: FontUtility.primaryTextFont,
            ),
          ),
          Text(widget.foodItem.description,
              style: TextStyle(
                fontSize: 16 * screenWidth / 400, // Adjust the value as needed
                color: ColorUtils.secondaryTextColor,
                fontFamily: FontUtility.primaryTextFont,
              )),
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
