import 'package:bite_buddy/Model/FooItem.dart';
import 'package:bite_buddy/Views/Admin/Components/DetailsFoodView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Utility/Utility.dart';

class FoodItemView extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemView({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailsFoodView(foodItem: foodItem);
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
                      imageUrl: foodItem.pictureUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    foodItem.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorUtils.secondaryTextColor,
                      fontFamily: FontUtility.primaryTextFont,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return DetailsFoodView(foodItem: foodItem);
            // }));
          },
          icon: Icon(
            Icons.more_vert,
            color: ColorUtils.secondaryColor,
          ),
        ),
      )
    ]);
  }
}
