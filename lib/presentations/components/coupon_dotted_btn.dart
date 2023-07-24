import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CouponDottedBtn extends StatelessWidget {
  final String textBtn;
  const CouponDottedBtn({Key? key, required this.textBtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        color: kPrimaryColor,
        strokeWidth: 3,
        dashPattern: [10, 6],
        child: ClipRRect(
          child: Container(
            width: 150,
            height: 40,
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  textBtn,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
