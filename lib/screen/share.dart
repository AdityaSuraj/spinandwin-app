import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/widget/drawer.dart';

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String _referalcode;

  _getcode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String referalcode = sharedPreferences.getString("referalcode");
    setState(() {
      _referalcode = referalcode;
    });
  }

  @override
  void initState() {
    super.initState();
    _getcode();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Share app"),
      ),
      body: Container(
        child: Container(
          width: size.width,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: grad_one,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Share Stream App",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "For each sharing you will earn 💠10 diamonds",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: Text(
                  "Referal Code : $_referalcode",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.white,
                child: Text(
                  "Share",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Share.text(
                    "Share The Stream App",
                    "Download The Stream App From our website and Earn 10 diamonds\nMy referal code is : $_referalcode \nDownload form : http://freefirediamond.tk/ ",
                    "text/plain",
                  );
                },
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "By sharing you abide with all t&c",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
