import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

import '../../Model/User.dart';
import '../../Utility/SharedPreference.dart';
import '../Login/Login.dart';

class DrawerWidget extends StatelessWidget {
  final User user;

  const DrawerWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
return Drawer(
      child: GlassContainer(
        blur: 10,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    user.email ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                UserPreferences().clear();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Login()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
