import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class SizeWidget extends StatefulWidget {
  const SizeWidget({Key? key}) : super(key: key);

  @override
  State<SizeWidget> createState() => _SizeWidgetState();
}

class _SizeWidgetState extends State<SizeWidget> {
  bool _small = false;
  bool _medium = false;
  bool _large = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MaterialButton(
            elevation: 0.0,
            color: _small ? Colors.black : kPrimaryLightColor,
            onPressed: () {
              setState(() {
                _small = true;
                _medium = false;
                _large = false;
              });
            },
            child: Text(
              'Small',
              style:
                  TextStyle(color: _small ? kPrimaryLightColor : Colors.black),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          medium(),
          SizedBox(
            width: 20,
          ),
          large(),
        ],
      ),
    );
  }

  Widget medium() {
    return MaterialButton(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: _medium ? Colors.black : kPrimaryLightColor,
      onPressed: () {
        setState(() {
          _medium = true;
          _small = false;
          _large = false;
        });
      },
      child: Text(
        'Medium',
        style: TextStyle(
          color: _medium ? kPrimaryLightColor : Colors.black,
        ),
      ),
    );
  }

  Widget large() {
    return MaterialButton(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: _large ? Colors.black : kPrimaryLightColor,
      onPressed: () {
        setState(() {
          _large = true;
          _small = false;
          _medium = false;
        });
      },
      child: Text(
        'Large',
        style: TextStyle(
          color: _large ? kPrimaryLightColor : Colors.black,
        ),
      ),
    );
  }
}
