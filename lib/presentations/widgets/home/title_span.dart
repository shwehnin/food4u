import 'package:flutter/material.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';

class TitleSpan extends StatelessWidget {
  const TitleSpan(
      {Key? key, required this.firstValue, required this.secondValue})
      : super(key: key);
  final String firstValue;
  final String secondValue;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$firstValue',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kHeadingColor,
            ),
          ),
          TextSpan(
            text: '$secondValue',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: kHeadingColor,
            ),
          ),
        ],
      ),
    );
  }
}
