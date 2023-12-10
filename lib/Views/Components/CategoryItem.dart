import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Model/Category.dart';
import '../../Utility/Utility.dart';
import 'CategoryWiseFoodList.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CategoryWiseFoodList(category: category)));
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
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Hero(
                    tag:
                        'categoryHero${category.idCategory}', // Unique Hero tag
                    child: CachedNetworkImage(
                      imageUrl: category.strCategoryThumb,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator()), // Optional
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error), // Optional
                    ),
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
                        category.strCategory,
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
