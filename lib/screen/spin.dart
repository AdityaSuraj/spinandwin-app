import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:http/http.dart' as http;
import 'package:spinandwin/constant/link.dart';

class SpinScreen extends StatefulWidget {
  @override
  _SpinScreenState createState() => _SpinScreenState();
}

class _SpinScreenState extends State<SpinScreen> {
  String _diamonds, _balance;
  final StreamController _dividerController = StreamController<int>();
  final _wheelNotifier = StreamController<double>();

  @override
  void dispose() {
    super.dispose();
    _dividerController.close();
  }

  _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String balance = sharedPreferences.getString("balance");
    String diamonds = sharedPreferences.getString("diamond");
    setState(() {
      _diamonds = diamonds;
      _balance = balance;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Spin"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Winnings\n♦$_diamonds",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Deposit\n₹$_balance",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: <Widget>[
                Center(
                  child: SpinningWheel(
                    Image.asset(
                      "assets/spinwheel.png",
                      height: 310,
                      width: 310,
                      fit: BoxFit.cover,
                    ),
                    width: 310,
                    height: 310,
                    dividers: 8,
                    canInteractWhileSpinning: false,
                    initialSpinAngle: Random().nextDouble() * pi * 2,
                    spinResistance: 0.2,
                    onUpdate: _dividerController.add,
                    onEnd: (v) async {
                      final Map<int, String> labels = {
                        1: "-50",
                        2: "40",
                        3: "50",
                        4: "60",
                        5: "70",
                        6: "80",
                        7: "90",
                        8: "100",
                      };
                      int diamonds = int.parse(_diamonds);
                      diamonds = diamonds + int.parse(labels[v]);
                      setState(() {
                        _diamonds = diamonds.toString();
                      });
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      String userid = sharedPreferences.getString("userid");
                      http.Response response = await http.post(
                          "$rootlink/spin.php",
                          body: {"userid": userid, "value": labels[v]});
                      String serres = response.body;
                     
                      
                        sharedPreferences.setString(
                            "diamond", diamonds.toString());
                      if (serres == "1") {
                       print(serres);
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

                      _dividerController.add(v);
                    },
                    shouldStartOrStop: _wheelNotifier.stream,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.transparent,
                  ),
                )
              ],
            ),
            StreamBuilder(
                stream: _dividerController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return snapshot.hasData
                        ? score(snapshot.data)
                        : SizedBox.shrink();
                  } else {
                    return Container();
                  }
                }),
            InkWell(
              onTap: () async {
                int balance = int.parse(_balance);
                if (balance == 0) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Alert"),
                        content: Text(
                          "You haven't enough balance , deposit using your api and try",
                        ),
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
                  _wheelNotifier.sink
                      .add((Random().nextDouble() * 6000) + 2000);
                  int balance = int.parse(_balance);
                  balance = balance - 1;
                  setState(() {
                    _balance = balance.toString();
                  });
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString("balance", balance.toString());
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Spin And Win",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget score(int selected) {
    final Map<int, String> labels = {
      1: "-50",
      2: "40",
      3: "50",
      4: "60",
      5: "70",
      6: "80",
      7: "90",
      8: "100",
    };

    // setState(() {
    //   _diamonds = diamonds.toString();
    // });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: TextField(
        controller: TextEditingController(text: "${labels[selected]}"),
        textAlign: TextAlign.center,
        decoration: InputDecoration(border: InputBorder.none),
        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
        onChanged: (v) {
          print(v);
        },
        readOnly: true,
      ),
    );
  }
}

class Score extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: "40",
    2: "50",
    3: "60",
    4: "70",
    5: "80",
    6: "90",
    7: "100",
    8: "-50",
  };

  Score(this.selected);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Text(
        "${labels[selected]}",
        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
      ),
    );
  }
}
