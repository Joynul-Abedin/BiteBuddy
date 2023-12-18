import 'package:bite_buddy/Model/FooItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Model/Category.dart';
import '../../../Utility/Utility.dart';
import 'CategoryWiseFoodList.dart';

class FoodItemUserView extends StatelessWidget {
  final FoodItem foodItem;
  const FoodItemUserView({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
        },
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
          child: GridTile(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[

                // SizedBox(
                //   height: double.infinity,
                //   width: double.infinity,
                //   child: Hero(
                //     tag:
                //         'categoryHero${category.idCategory}', // Unique Hero tag
                //     child: CachedNetworkImage(
                //       imageUrl: category.strCategoryThumb,
                //       fit: BoxFit.fitWidth,
                //       placeholder: (context, url) => const Center(
                //           child: CircularProgressIndicator()), // Optional
                //       errorWidget: (context, url, error) =>
                //           const Icon(Icons.error), // Optional
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: foodItem.pictureUrl,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator()), // Optional
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // Optional
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Container(
                      color: Colors.grey.withOpacity(0.5),
                      child: Text(
                        foodItem.name,
                        style: TextStyle(
                          color: ColorUtils.secondaryTextColor,
                            fontFamily: FontUtility.primaryTextFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
