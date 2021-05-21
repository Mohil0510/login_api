import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:login_api/config.dart';
import 'package:login_api/login_page.dart';
import 'package:login_api/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Sign Up ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UserName',
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
                            contentPadding: EdgeInsets.fromLTRB(3, 8, 10, 5),
                          ),
                          onChanged: (val) => name = val,
                          // autovalidateMode: AutovalidateMode.always,
                          validator: (_email) {
                            bool _emailValid =
                                RegExp(r"^[a-zA-z]+").hasMatch(_email);
                            if (_email.isEmpty) return 'Please enter your Name';
                            if (!_emailValid) return 'Please Enter valid Name';
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          onChanged: (val) => email = val,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(3, 8, 10, 5),
                          ),
                          // autovalidateMode: AutovalidateMode.always,
                          validator: (_email) {
                            bool _emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_email);
                            if (_email.isEmpty)
                              return 'Please enter your email';
                            if (!_emailValid) return 'Please Enter valid email';
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          onChanged: (val) => password = val,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(3, 8, 10, 5),
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
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'By Tapping Sign Up & Accept You ackowledge that you have the Privacy Policy and agree to the Terms Of Service.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                          ],
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
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Login',
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
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
          onTap: signupApi,
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
                'Sign Up & Accept',
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

  void signupApi() async {
    // loader true
    if (_form.currentState.validate()) {
      var response = await post(
        Uri.parse("${AppConfig.baseUrl}/register"),
        body: {
          "name": "$name",
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
        List errors = decoded["data"]["error"];
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: errors.map((e) => Text(e)).toList(),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK"))
            ],
          ),
        );
      }
    }
  }
}
