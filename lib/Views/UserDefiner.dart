import 'package:bite_buddy/Views/Admin/AdminHomePage.dart';
import 'package:bite_buddy/Views/User/HomePage.dart';
import 'package:flutter/material.dart';

class UserDefiner extends StatelessWidget {
  final String userType;
  const UserDefiner({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType == 'admin') {
      // Navigate to the admin screen if userType is 'admin'
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminHomePage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecipeHelper(),
        ),
      );
    }

    // Return an empty container if userType is 'admin' to avoid rendering the current screen
    return Container();
  }
}
