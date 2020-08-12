import 'package:flutter/material.dart';

Widget noNetwork(Size size) {
  return Container(
    width: size.width,
    height: size.height - 210,
    // color: Colors.black.withOpacity(0.2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/nonet.png",
          height: 180,
        ),
        Text(
          "Oops!",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          "Check Your Network Connection!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.refresh),
            Text(
              "Tap to refresh",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    ),
  );
}
