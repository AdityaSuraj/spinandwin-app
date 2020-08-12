import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/constant/link.dart';
import 'package:spinandwin/screen/home.dart';
import 'package:spinandwin/screen/signup.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController(),
      _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: grad_one),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/icon.png",
                height: 124,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "Free Diamond",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              textField(controller: _email),
              SizedBox(
                height: 12,
              ),
              textField(
                icon: Icons.lock,
                label: "Password",
                controller: _password,
              ),
              SizedBox(
                height: 8,
              ),
              RaisedButton(
                color: Colors.white,
                child: Text("Login"),
                onPressed: () async {
                  http.Response response = await http.post(
                      "$rootlink/login.php",
                      body: {"email": _email.text, "password": _password.text});
                  String resstr = response.body;
                  print(resstr);
                  try {
                    List json = jsonDecode(resstr);
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString("userid", json[0]['userid']);
                    sharedPreferences.setString("name", json[0]['name']);
                    sharedPreferences.setString("email", json[0]['email']);
                    sharedPreferences.setString("phone", json[0]['phone']);
                    sharedPreferences.setString(
                        "referalcode", json[0]['referalcode']);
                    sharedPreferences.setString("balance", json[0]['balance']);
                    sharedPreferences.setString("diamond", json[0]['diamond']);
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));
                  } catch (err) {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text("Alert"),
                          content: Text("Wrong Email id or Password..."),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        ));
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SignupScreen();
                  }));
                },
                child: Text(
                  "New user ? Signup here",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget textField(
    {String label, TextEditingController controller, IconData icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon == null ? Icons.email : icon,
          color: Colors.white,
        ),
        labelText: label == null ? "Email ID" : label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    ),
  );
}
