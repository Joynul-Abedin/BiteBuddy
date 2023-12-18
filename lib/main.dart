import 'package:bite_buddy/Utility/Constants.dart';
import 'package:bite_buddy/Views/Admin/OwnerHomePage.dart';
import 'package:bite_buddy/Views/Login/Login.dart';
import 'package:bite_buddy/Views/User/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Database/DatabaseHelper.dart';
import 'Utility/SharedPreference.dart';
import 'Views/Admin/StoreSetUpPage.dart';

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
  runApp(MyApp());

  DatabaseHelper.instance.database;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final isLoggedIn =
      UserPreferences().getBoolValue(Constants.IS_LOGGEDIN, false);
  final userType =
      UserPreferences().getStringValue(Constants.USER_TYPE, 'customer');

  final hasStore = UserPreferences().getBoolValue(Constants.HAS_STORE, false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? userType == 'customer'
              ? const RecipeHelper()
              : hasStore ? const OwnerHomePage() : StoreSetupPage()
          : const Login(),
      // home: const RecipeHelper(),
    );
  }
}
