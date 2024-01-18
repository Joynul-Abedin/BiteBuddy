import 'dart:convert';

import 'package:bite_buddy/Controllers/Store/StoreController.dart';
import 'package:bite_buddy/Utility/Constants.dart';
import 'package:bite_buddy/Views/Admin/OwnerHomePage.dart';
import 'package:bite_buddy/Views/Login/Login.dart';
import 'package:bite_buddy/Views/User/LnadingPage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import 'Utility/SharedPreference.dart';
import 'Views/Admin/StoreSetUpPage.dart';
import 'Views/User/Cart/Provider/CartProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  MobileAds.instance.initialize();
  ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLoggedIn = false;
  String userType = 'customer';
  bool hasStore = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    isLoggedIn = await isTokenValid(); // Implement this function
    if (isLoggedIn) {
      userType =
          UserPreferences().getStringValue(Constants.USER_TYPE, 'customer');
      hasStore = UserPreferences().getBoolValue(Constants.HAS_STORE, false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> isTokenValid() async {
    String? token = UserPreferences().getStringValue(Constants.TOKEN, '');
    debugPrint('Expiration time- ${JwtDecoder.getExpirationDate(token)}');
    debugPrint('IsExpired- ${JwtDecoder.isExpired(token)}');
    return !JwtDecoder.isExpired(token);
  }

  Future<void> getNewToken() async {
    String? email = UserPreferences().getStringValue(Constants.USER_EMAIL, '');
    String? password =
        UserPreferences().getStringValue(Constants.USER_PASSWORD, '');
    if (password == null) return;

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];
      UserPreferences().setStringValue(Constants.TOKEN, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     ),
    //   );
    // }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? userType == 'customer'
              ? const LandingPage()
              : hasStore
                  ? const OwnerHomePage()
                  : StoreSetupPage(controller: StoreController())
          : const Login(),
    );
  }
}
