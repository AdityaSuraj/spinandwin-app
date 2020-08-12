import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/constant/link.dart';
import 'package:spinandwin/widget/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:spinandwin/widget/functions.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  String _currentDiamonds;
  TextEditingController _email = TextEditingController(),
      _amount = TextEditingController();

  _getCurrentBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String diamond = sharedPreferences.getString("diamond");
    setState(() {
      _currentDiamonds = diamond;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentBalance();
    showad();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Withdraw"),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            width: size.width,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              gradient: grad_one,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/icon.png",
                  height: 84,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/diamond.png",
                      height: 34,
                    ),
                    Text(
                      " $_currentDiamonds",
                      style: TextStyle(
                        fontSize: 52,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _email,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      labelText: "Character ID",
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
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _amount,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.confirmation_number,
                        color: Colors.white,
                      ),
                      labelText: "Amount",
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
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Withdraw",
                    style: TextStyle(
                        color: color_primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    int diamonds = int.parse(_currentDiamonds);
                    if (diamonds < 5001) {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text("Alert"),
                            content: Text(
                                "You haven't enough diamonds to withdraw..."),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              )
                            ],
                          ));
                    } else {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      String userid = sharedPreferences.getString("userid");
                      http.Response response = await http
                          .post("$rootlink/withdraw.php", body: {
                        "userid": userid,
                        "value": _amount.text,
                        "email": _email.text
                      });
                      String resstr = response.body;
                      if (resstr == "1") {
                        int currdia = int.parse(_currentDiamonds);
                        currdia = currdia - int.parse(_amount.text);
                        sharedPreferences.setString(
                            "diamond", currdia.toString());
                        setState(() {
                          _currentDiamonds = currdia.toString();
                        });
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Alert"),
                              content: Text(
                                  "Your withdraw is in process we will soon contact you..."),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                )
                              ],
                            ));
                      } else {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Alert"),
                              content: Text("Something went wrong..."),
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
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Minimum 5000 coins require to withdraw",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
