import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class RadioCard extends StatefulWidget {
  const RadioCard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RadioCardState createState() => _RadioCardState();
}

class _RadioCardState extends State<RadioCard> {
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
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose of ${widget.title}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 0,
                    groupValue: radioValue,
                    onChanged: handleRadioValueChange,
                    activeColor: kPrimaryColor,
                    title: Text('ဂျုံခေါက်ဆွဲ'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 2,
                    groupValue: radioValue,
                    onChanged: handleRadioValueChange,
                    activeColor: kPrimaryColor,
                    title: Text('ညှပ်ခေါက်ဆွဲ'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 3,
                    groupValue: radioValue,
                    onChanged: handleRadioValueChange,
                    activeColor: kPrimaryColor,
                    title: Text('ကြာဇံ'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
