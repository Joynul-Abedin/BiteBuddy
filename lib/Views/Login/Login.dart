import 'dart:convert';

import 'package:bite_buddy/Controllers/Store/StoreController.dart';
import 'package:bite_buddy/Utility/SharedPreference.dart';
import 'package:bite_buddy/Views/Admin/StoreSetUpPage.dart';
import 'package:bite_buddy/Views/User/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Model/User.dart';
import '../../Utility/Colors.dart';
import '../../Utility/Constants.dart';
import '../../Utility/Functions.dart';
import '../Admin/OwnerHomePage.dart';
import '../Register/Register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool isLogin = false;
  late String userType;
  bool obscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserPreferences sharedPreference;
  late StoreController storeController;

  @override
  initState() {
    super.initState();
    UserPreferences().init();
    sharedPreference = UserPreferences();
    storeController = StoreController();
  }

  Future<bool> login(String email, String password) async {
    setState(() {
      isLoading = true; // Start loading
    });


    final Map<String, String> requestData = {
      "email": email,
      "password": password,
    };

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/login'),
      body: json.encode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint(data.toString());
      final token = data['token'];
      final user = User.fromJson(data['user']);
      debugPrint(user.toString());
      sharedPreference.setBoolValue(Constants.IS_LOGGEDIN, true);
      sharedPreference.setStringValue(Constants.TOKEN, token);
      sharedPreference.setStringValue(Constants.USER_ID, user.sId!);
      sharedPreference.setStringValue(Constants.USER_EMAIL, user.email!);
      sharedPreference.setStringValue(Constants.USER_PASSWORD, password);
      sharedPreference.setStringValue(Constants.USER_TYPE, user.role!);
      sharedPreference.setBoolValue(Constants.HAS_STORE, user.hasStore!);
      debugPrint(user.role!);
      if (user.role case 'owner') {
        if (user.hasStore == false) {
          FunctionsUtility.showToastMessage(
              'You need to set the store first', Colors.red);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StoreSetupPage(
                      controller: storeController,
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OwnerHomePage()),
          ); // Replace with your admin page widget
        }
      } else if (user.role case 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeHelper(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeHelper(),
          ),
        );
      }
      setState(() {
        isLoading = false; // Stop loading when login process is done
      });
      return true;
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Unknown error occurred';
      FunctionsUtility.showToastMessage(errorMessage, Colors.red);
      setState(() {
        isLoading = false; // Stop loading when login process is done
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        )),
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.primaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Image(
                image: AssetImage('assets/Onboard-Without-BG.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 40.0, left: 8.0, right: 8.0, bottom: 24),
                          child: Text('Login to Your Account',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.textFieldColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              TextFormField(
                                obscureText: obscured,
                                obscuringCharacter: '*',
                                controller: _password,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.textFieldColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscured = !obscured;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 4.0),
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                    color: Color.fromRGBO(120, 107, 203, 1)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        GestureDetector(
                          onTap: () {
                            if (!isLoading) { // Check if not already loading
                              login(_email.text, _password.text);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primaryColor,
                            ),
                            child: Center(
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
                                  : const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Color.fromRGBO(120, 107, 203, 1),
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Register()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
