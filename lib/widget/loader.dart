import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future customLoader(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
            child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitWave(color: Colors.black),
                // SpinKitFadingCube(color: Colors.black),
                SizedBox(height: 20),
                Text("Processing",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 12,
                        color: Colors.black,
                        decoration: TextDecoration.none))
              ],
            ),
          ),
        ));
      });
}
