import 'package:flutter/material.dart';
import 'package:spinandwin/widget/drawer.dart';

class DisclaimerScreen extends StatefulWidget {
  @override
  _DisclaimerScreenState createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer"),
      ),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "For all the transaction on your account you are abide with our terms and conditions. All transactions are on behalf of you.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
