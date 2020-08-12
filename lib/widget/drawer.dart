import 'package:flutter/material.dart';
import 'package:spinandwin/constant/color.dart';
import 'package:spinandwin/screen/disclamer.dart';
import 'package:spinandwin/screen/home.dart';
import 'package:spinandwin/screen/privacy.dart';
import 'package:spinandwin/screen/share.dart';

class CustomDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Container(
        width: 230,
        height: size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 220,
              width: 230,
              color: color_primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/icon.png",
                    height: 84,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Free Diamond",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (conext) {
                  return HomeScreen();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.panorama_horizontal),
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return PrivacyScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "Disclaimer",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DisclaimerScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text(
                "Share And Earn",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ShareScreen();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
