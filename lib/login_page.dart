import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:login_api/profile.dart';
import 'package:login_api/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //     icon: Icon(Icons.arrow_back_ios_sharp),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => SignUpPage()),
                //       );
                //     }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UserName or Email',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding:
                                    EdgeInsets.fromLTRB(3, 8, 10, 5),
                              ),
                              // autovalidateMode: AutovalidateMode.always,
                              onChanged: (value) => email = value,
                              validator: (_email) {
                                bool _emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(_email);
                                if (_email.isEmpty)
                                  return 'Please enter your email';
                                if (!_emailValid)
                                  return 'Please Enter valid email';
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              onChanged: (value) => password = value,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(3, 8, 10, 5),
                              ),
                              // autovalidateMode: AutovalidateMode.always,
                              validator: (_password) {
                                bool _passwordValid =
                                    RegExp(r"^[0-9]+$").hasMatch(_password);
                                if (_password.isEmpty)
                                  return 'Please enter your password';
                                if (!_passwordValid)
                                  return 'Please Enter valid password';
                                return null;
                              },
                            ),
                          ],
                        ),
                        key: _form,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'You Have Account? ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
          onTap: loginFunc,
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                'Log in',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginFunc() async {
    if (_form.currentState.validate()) {
      var response = await post(
        Uri.parse("${AppConfig.baseUrl}/login"),
        body: {
          "email": "$email",
          "password": "$password",
          "device_token": "b51a9597a0ecdc8eb51c6e9febe1dff5",
          "device_type": "${Platform.isAndroid ? "android" : "ios"}",
          "device_id": "123123123123"
        },
      );
      if (response.statusCode == 200) {
        // loader true
        var decoded = jsonDecode(response.body);

        // store creds
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("TOKEN", decoded["data"]["token"]);

        Fluttertoast.showToast(
          msg: "${decoded["message"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
        Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
      } else if (response.statusCode == 400) {
        // loader true
        var decoded = jsonDecode(response.body);
        print(decoded);
        Fluttertoast.showToast(
          msg: "${decoded["message"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }
}
