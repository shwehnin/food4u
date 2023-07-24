import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class CustomAddressBtn extends StatelessWidget {
  final String btnName;
  const CustomAddressBtn({Key? key, required this.btnName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      child: OutlinedButton(
        onPressed: () {},
        // borderSide: BorderSide(color: kPrimaryColor, width: 2),
        child: Text(
          btnName,
          style: TextStyle(
              fontSize: 18, color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
