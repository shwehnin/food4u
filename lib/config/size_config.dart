import 'package:flutter/material.dart';

final TextStyle kHeading =
    TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white);
const TextStyle kHeadingFour =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
const TextStyle kbodyText1 = TextStyle(
  fontSize: 18,
  color: Colors.white,
);
const TextStyle kbodyText2 = TextStyle(
  fontSize: 18,
  color: Colors.black,
);
const TextStyle kbodyText = TextStyle(
  fontSize: 18,
);


// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight, context) {
  double screenHeight = MediaQuery.of(context).size.height;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth, context) {
  double screenWidth = MediaQuery.of(context).size.width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

