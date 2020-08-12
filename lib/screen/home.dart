import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/constant/link.dart';
import 'package:spinandwin/screen/deposit.dart';
import 'package:spinandwin/screen/giveaway.dart';
import 'package:spinandwin/screen/spin.dart';
import 'package:spinandwin/screen/withdraw.dart';
import 'package:spinandwin/widget/drawer.dart';
import 'package:spinandwin/widget/functions.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _diamonds, _balance, _name, _userid;

  _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String balance = sharedPreferences.getString("balance");
    String diamonds = sharedPreferences.getString("diamond");
    String name = sharedPreferences.getString("name");
    String userid = sharedPreferences.getString("userid");
    setState(() {
      _name = name;
      _diamonds = diamonds;
      _balance = balance;
      _userid = userid;
    });
  }

  _getandsetdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    http.Response response = await http.post("$rootlink/getinidata.php",
        body: {"userid": sharedPreferences.getString("userid")});
    String resstr = response.body;
    print(resstr);
    try {
      List json = jsonDecode(resstr);
      sharedPreferences.setString("userid", json[0]['userid']);
      sharedPreferences.setString("name", json[0]['name']);
      sharedPreferences.setString("email", json[0]['email']);
      sharedPreferences.setString("phone", json[0]['phone']);
      sharedPreferences.setString("referalcode", json[0]['referalcode']);
      sharedPreferences.setString("balance", json[0]['balance']);
      sharedPreferences.setString("diamond", json[0]['diamond']);
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _getandsetdata();
    showad();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Free Diamond"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 390,
                width: size.width,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: grad_one,
                ),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/icon.png",
                      height: 84,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Name: $_name",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Container(
                          width: size.width / 2 - 17,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Winnings",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/diamond.png",
                                    height: 24,
                                  ),
                                  Text(
                                    " $_diamonds",
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 120,
                          width: 2,
                        ),
                        Container(
                          width: size.width / 2 - 17,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Balance",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹$_balance",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return WithdrawScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Withdraw",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: color_primary,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DepositScreen();
                        }));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Deposit",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: color_primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // height: 160,
                width: size.width,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: grad_one,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SpinScreen();
                        }));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Let's Spin",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: color_primary,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return GiveawayScreen("Daily Giveaway");
                        }));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Daily Giveaway",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: color_primary,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return GiveawayScreen("DJ ALOK Giveaway");
                        }));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "DJ Alok Giveaway",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: color_primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 42,
              )
            ],
          ),
        ),
      ),
    );
  }
}
