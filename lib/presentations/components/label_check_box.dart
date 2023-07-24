import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  LabeledCheckbox({
    required this.label,
    required this.subLabel,
    required this.contentPadding,
    required this.value,
    required this.onTap,
    required this.activeColor,
    required this.fontSize,
    this.gap = 4.0,
    this.bold = false,
  });

  final String label;
  final String subLabel;
  final EdgeInsets contentPadding;
  final bool value;
  final Function onTap;
  final Color activeColor;
  final double fontSize;
  final double gap;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(!value),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: kPrimaryColor,
                    ),
                    child: Checkbox(
                      value: value,
                      activeColor: activeColor,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) => onTap(val),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Flexible(
              child: Text(
                subLabel,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
