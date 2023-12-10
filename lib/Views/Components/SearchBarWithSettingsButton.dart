import 'package:flutter/material.dart';

import '../../Utility/Utility.dart';

class SearchBarWithSettingsButton extends StatelessWidget {
  const SearchBarWithSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        decoration: BoxDecoration(
          color: ColorUtils.secondaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Icon(
                Icons.search,
                color: ColorUtils.primaryColor,
              ),
            ),
            Expanded(
              // Expanded widget to ensure the TextField takes the remaining width
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search any recipe",
                  hintStyle: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontFamily: FontUtility.primaryTextFont,
                    fontSize: 16.0,
                  ),
                  border:
                      InputBorder.none, // Removes underline of the input field
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
