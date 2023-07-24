import 'package:flutter/material.dart';

class CouponDropdown extends StatefulWidget {
  CouponDropdown({Key? key}) : super(key: key);

  @override
  _CouponDropdownState createState() => _CouponDropdownState();
}

class _CouponDropdownState extends State<CouponDropdown> {
  var _selectedValue = "CLOSED";
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      style: TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
      items: ["CLOSED", "OPEN"].map((String e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(
            e,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (value) {
        _selectedValue = value!;
        setState(() {});
      },
    );
  }
}
