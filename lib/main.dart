import 'package:bite_buddy/Views/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Database/DatabaseHelper.dart';
import 'Utility/SharedPreference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  MobileAds.instance.initialize().then((InitializationStatus status) {
    debugPrint('Initialization done: ${status.adapterStatuses}');
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: <String>[
          "GADSimulatorID",
          "18abe969dce86abc61b0b6ff0fcf0a16"
        ],
      ),
    );
  });
  runApp(const MyApp());

  DatabaseHelper.instance.database;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Login(),
      // home: const RecipeHelper(),
    );
  }
}
