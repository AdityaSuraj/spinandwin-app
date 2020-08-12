import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/screen/home.dart';
import 'package:spinandwin/screen/login.dart';
import 'package:spinandwin/screen/splash.dart';
import 'package:spinandwin/widget/functions.dart';
import 'package:spinandwin/widget/nonetwork.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: color_primary));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(primarySwatch: color_primary),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isShowSplash = true;
  bool _isOnline = true;
  bool _isLogin = true;

  _getuserid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("userid") == null) {
      setState(() {
        _isLogin = false;
      });
    } else {
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isShowSplash = false;
      });
    });
    checkConnection().then((res) {
      setState(() {
        _isOnline = res;
      });
    });
    _getuserid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isShowSplash
          ? SplashScreen()
          : !_isOnline
              ? Container(
                  decoration: BoxDecoration(gradient: grad_one),
                  child: Center(
                    child: noNetwork(MediaQuery.of(context).size),
                  ),
                )
              : _isLogin ? HomeScreen() : LoginScreen(),
    );
  }
}
