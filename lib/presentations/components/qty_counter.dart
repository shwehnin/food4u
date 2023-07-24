import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int intialValue;

  final ValueChanged<int>? onChanged;

  NumericStepButton(
      {Key? key,
      required this.intialValue,
      this.minValue = 0,
      this.maxValue = 100,
      this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int counter = 0;
  @override
  void initState() {
    super.initState();
    counter = widget.intialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: kBlackColor),
            padding: EdgeInsets.symmetric(vertical: 4.0),
            iconSize: 18.0,
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                if (counter > widget.minValue) {
                  counter--;
                }
                widget.onChanged!(counter);
              });
            },
          ),
          Container(
            width: 30,
            child: Text(
              '$counter',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: kBlackColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0),
            iconSize: 18.0,
            color: kBlackColor,
            onPressed: () {
              setState(() {
                if (counter < widget.maxValue) {
                  counter++;
                }
                widget.onChanged!(counter);
              });
            },
          ),
        ],
      ),
    );
  }
}
