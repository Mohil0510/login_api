import 'package:flutter/material.dart';
import 'package:login_api/profile.dart';
import 'package:login_api/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check token
    checkCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("TOKEN") != null && prefs.getString("TOKEN") != "") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
    }
  }
}
