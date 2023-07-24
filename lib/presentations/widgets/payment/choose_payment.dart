import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class ChoosePayment extends StatefulWidget {
  const ChoosePayment({Key? key}) : super(key: key);

  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  int radioValue = -1;

  handleRadioValueChange(final value) {
    setState(() {
      radioValue = value;
      switch (radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: 0,
                groupValue: radioValue,
                onChanged: handleRadioValueChange,
                activeColor: kPrimaryColor,
                title: Text(
                  'KBZ Pay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset('assets/images/kbz.png',
                      width: 60, height: 50),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: 1,
                groupValue: radioValue,
                onChanged: handleRadioValueChange,
                activeColor: kPrimaryColor,
                title: Text(
                  'Wave Money',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset('assets/images/wave.png',
                      width: 60, height: 50),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: 2,
                groupValue: radioValue,
                onChanged: handleRadioValueChange,
                activeColor: kPrimaryColor,
                title: Text(
                  'Cash on Delivery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset('assets/images/cash.png',
                      width: 60, height: 50),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
