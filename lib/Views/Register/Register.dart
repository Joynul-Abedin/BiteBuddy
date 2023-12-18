import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Utility/Colors.dart';
import '../../Utility/Constants.dart';
import '../../Utility/Functions.dart';
import '../Login/Login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _role = TextEditingController();
  bool obscured = true;

  Future<void> registration(String name, String email, String password,
      String confirmPassword, String role) async {
    if (password != confirmPassword) {
      FunctionsUtility.showToastMessage('Password does not match!', Colors.red);
      return;
    }

    bool isValidEmail(String email) {
      final RegExp regex =
          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
      return regex.hasMatch(email);
    }

    if (email.isEmpty || !isValidEmail(email)) {
      FunctionsUtility.showToastMessage(
          'Please enter a valid email.', Colors.red);
      return;
    }
    if (password.isEmpty || password.length < 6) {
      FunctionsUtility.showToastMessage(
          'Password should be at least 6 characters.', Colors.red);
      return;
    }

    final Map<String, String> requestData = {
      "name": name,
      "email": email,
      "password": password,
      "role": role.toLowerCase(),
    };

    debugPrint(requestData.toString());

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/signup'),
      body: json.encode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      debugPrint(data.toString());
      FunctionsUtility.showToastMessage(
          'Registration Successful.', Colors.green);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
      return;
    } else {
      FunctionsUtility.showToastMessage(
          response.body, Colors.green);
      return;
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Image(
                  image: AssetImage('assets/Onboard-Without-BG.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(60),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 40.0, left: 8.0, right: 8.0, bottom: 24),
                            child: Text('Create New Account',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'First Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      TextFormField(
                                        controller: _firstName,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.textFieldColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 4.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Last Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      TextFormField(
                                        controller: _lastName,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.textFieldColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 4.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.textFieldColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
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
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                TextFormField(
                                  obscureText: obscured,
                                  obscuringCharacter: '*',
                                  controller: _confirmPassword,
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
                          const SizedBox(height: 8.0),
                          // Role DropDown Box
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Role',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                DropdownButtonFormField<String>(
                                  value:
                                      _role.text.isEmpty ? 'Admin' : _role.text,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors
                                        .textFieldColor, // Replace with your color
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
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
                                  items: ['Admin', 'User']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _role.text = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          GestureDetector(
                            onTap: () {
                              debugPrint('${_role.text}');
                              registration(
                                '${_firstName.text} ${_lastName.text}',
                                _email.text,
                                _password.text,
                                _confirmPassword.text,
                                _role.text,
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryColor,
                              ),
                              child: const Center(
                                child: Text(
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
            ),
          ],
        ),
      ]),
    );
  }
}
