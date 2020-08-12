import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/constant/link.dart';
import 'package:spinandwin/widget/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:spinandwin/widget/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class GiveawayScreen extends StatefulWidget {
  final String type;
  GiveawayScreen(this.type);
  @override
  _GiveawayScreenState createState() => _GiveawayScreenState();
}

class _GiveawayScreenState extends State<GiveawayScreen> {
  String _userid;
  TextEditingController _email = TextEditingController();

  _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userid = sharedPreferences.getString("userid");
    setState(() {
      _userid = userid;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
    showad();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
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
                      height: 24,
                    ),
                    Text(
                      widget.type == "DJ ALOK Giveaway"
                          ? " 5 DJ ALOK Giveaway"
                          : " 5000",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Diamond Giveaway",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _email,
                    style: TextStyle(color: Colors.white),
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
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    if (_email.text == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text("Alert"),
                            content: Text("Enter Your email id first..."),
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
                      http.Response response;
                      if (widget.type == "DJ ALOK Giveaway") {
                        response = await http.post("$rootlink/joingiveaway.php",
                            body: {"contestid": "djalok", "userid": _userid});
                      } else {
                        response = await http.post("$rootlink/joingiveaway.php",
                            body: {"contestid": "daily", "userid": _userid});
                      }
                      String serres = response.body;
                      if (serres == "1") {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Alert"),
                              content: Text(
                                  "You have registered successfully for giveaway..."),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Enter In Giveaway",
                      style: TextStyle(
                        fontSize: 24,
                        color: color_primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Share with 5 people to enter in giveaway",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    if (canLaunch("https://wa.me/+919523770928") != null) {
                      launch("https://wa.me/+919523770928");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Giveaway Result",
                      style: TextStyle(
                        fontSize: 24,
                        color: color_primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Result will be announced 9:00 PM daily",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.type == "DJ ALOK Giveaway"
                      ? "5 winner daily"
                      : "1 winner daily",
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
