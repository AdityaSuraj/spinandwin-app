import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/constant/link.dart';
import 'package:spinandwin/widget/drawer.dart';
import 'package:spinandwin/widget/functions.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:http/http.dart' as http;

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  TextEditingController _email = TextEditingController(),
      _amount = TextEditingController();
  String _upiAddrErr;
  String _currentBalance;
  String _userid;

  _getCurrentBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String balance = sharedPreferences.getString("balance");
    String userid = sharedPreferences.getString("userid");
    setState(() {
      _currentBalance = balance;
      _userid = userid;
    });
  }

  Future<List<ApplicationMeta>> _appfuture;

  @override
  void initState() {
    super.initState();
    _getCurrentBalance();
    _appfuture = UpiPay.getInstalledUpiApplications();
  }

  Future<void> _onTap(ApplicationMeta app, BuildContext context) async {
    final err = _validateUpiAddress("glosirudh1149@ybl");
    if (err != null) {
      setState(() {
        _upiAddrErr = err;
      });
      return;
    }
    setState(() {
      _upiAddrErr = null;
    });
    final transRef = Random.secure().nextInt(1 << 32).toString();
    final a = await UpiPay.initiateTransaction(
      app: app.upiApplication,
      receiverUpiAddress: "glosirudh1149@ybl",
      receiverName: "User Name",
      transactionRef: transRef,
      amount: _amount.text,
    );
    print(a);

    if (a.status == UpiTransactionStatus.success) {
      http.Response response = await http.post("$rootlink/deposit.php",
          body: {"userid": _userid, "amount": _amount.text});
      String resstr = response.body;
      if (resstr == "1") {
        int currbal = int.parse(_currentBalance);
        currbal = currbal + int.parse(_amount.text);
        setState(() {
          _currentBalance = currbal.toString();
        });
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("balance", currbal.toString());
        showDialog(
            context: context,
            child: AlertDialog(
              title: Text("Alert"),
              content: Text(
                  "Transaction Success ${_amount.text} has been added to your account"),
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
              content: Text("Oops! transaction failed..."),
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
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Deposit")),
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
                Text(
                  "₹$_currentBalance",
                  style: TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _email,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
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
                    "Add Money",
                    style: TextStyle(
                        color: color_primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_amount.text == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text("Alert"),
                            content: Text("Amount Is Empty..."),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              )
                            ],
                          ));
                    } else if (int.parse(_amount.text) < 10) {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text("Alert"),
                            content: Text("Minimum deposit amount is 10!"),
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
                      showModalBottomSheet(
                          context: (context),
                          builder: (context) {
                            return Container(
                                width: size.width,
                                color: Colors.white,
                                child: FutureBuilder<List<ApplicationMeta>>(
                                  future: _appfuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Container();
                                    }
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Choose Payment Gateway to use",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Wrap(
                                          spacing: 12,
                                          children: snapshot.data.map((app) {
                                            return RaisedButton(
                                                child: Text(app.upiApplication
                                                    .getAppName()),
                                                onPressed: () {
                                                  _onTap(app, context);
                                                });
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          height: 42,
                                        ),
                                      ],
                                    );
                                  },
                                ));
                          });
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Minimum ₹10 Deposit\nYou need to have any UPI payment gateway installed in order to complete this transaction",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                // FutureBuilder<List<ApplicationMeta>>(
                //   future: _appfuture,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState != ConnectionState.done) {
                //       return Container();
                //     }
                //     return Wrap(
                //       children: snapshot.data.map((app) {
                //         return RaisedButton(
                //             child: Text(app.upiApplication.getAppName()),
                //             onPressed: () {
                //               _onTap(app);
                //             });
                //       }).toList(),
                //     );
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _validateUpiAddress(String value) {
  if (value.isEmpty) {
    return "UPI Address is required";
  }
  if (!UpiPay.checkIfUpiAddressIsValid(value)) {
    return "UPI Address is invalid";
  }
  return null;
}
