import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:spinandwin/constant/link.dart';
import 'package:spinandwin/screen/home.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _name = TextEditingController(),
      _email = TextEditingController(),
      _phone = TextEditingController(),
      _password = TextEditingController(),
      _referal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: size.height,
            decoration: BoxDecoration(gradient: grad_one),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/icon.png", height: 124),
                  SizedBox(
                    height: 12,
                  ),
                  Text("Free Diamond",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  textField(
                      label: "Name", controller: _name, icon: Icons.person),
                  SizedBox(
                    height: 12,
                  ),
                  textField(
                      label: "Email", controller: _email, icon: Icons.email),
                  SizedBox(
                    height: 12,
                  ),
                  textField(
                      label: "Phone Number",
                      controller: _phone,
                      icon: Icons.phone),
                  SizedBox(
                    height: 12,
                  ),
                  textField(
                      label: "Password",
                      controller: _password,
                      icon: Icons.lock),
                  SizedBox(
                    height: 12,
                  ),
                  textField(
                      label: "Referal Code(optional)",
                      controller: _referal,
                      icon: Icons.control_point_duplicate),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                      child: Text("Signup"),
                      onPressed: () async {
                        http.Response response =
                            await http.post("$rootlink/signup.php", body: {
                          "name": _name.text,
                          "email": _email.text,
                          "phone": _phone.text,
                          "password": _password.text,
                          "referal": _referal.text
                        });
                        String resstr = response.body;
                        try {
                          List json = jsonDecode(resstr);
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setString(
                              "userid", json[0]['userid']);
                          sharedPreferences.setString("name", json[0]['name']);
                          sharedPreferences.setString(
                              "email", json[0]['email']);
                          sharedPreferences.setString(
                              "phone", json[0]['phone']);
                          sharedPreferences.setString(
                              "referalcode", json[0]['referalcode']);
                          sharedPreferences.setString(
                              "balance", json[0]['balance']);
                          sharedPreferences.setString(
                              "diamond", json[0]['diamond']);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return HomeScreen();
                          }));
                        } catch (e) {
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text("Alert"),
                                content: Text(resstr),
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
                      })
                ],
              ),
            )),
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
