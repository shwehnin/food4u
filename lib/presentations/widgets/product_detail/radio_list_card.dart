import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/shared/custom_radio.dart';
import 'package:flutter/material.dart';

class RadioListCard extends StatefulWidget {
  RadioListCard(
      {Key? key,
      required this.title,
      required this.valueList,
      required this.type,
      required this.onSelect,
      required this.subLabelList})
      : super(key: key);

  Function(String) onSelect;
  final String title;
  final String type;
  final List<String> valueList;
  final List<String> subLabelList;

  @override
  _RadioListCardState createState() => _RadioListCardState();
}

class _RadioListCardState extends State<RadioListCard> {
  String itemValue = "";
  List<bool> checkboxValues = [];

  @override
  void initState() {
    super.initState();
    if (widget.valueList.length != 0) {
      for (int i = 0; i < widget.valueList.length; i++) {
        checkboxValues.add(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              GroupRadioButton(
                labelTextList: widget.valueList,
                label: [
                  for (int i = 0; i < widget.valueList.length; i++)
                    Text(widget.valueList[i].toString()),
                ],
                subLabel: widget.subLabelList.length != 0
                    ? [
                        for (int i = 0; i < widget.valueList.length; i++)
                          Text(
                              'K ${currencyFormat.format(int.parse(widget.subLabelList[i]))}')
                      ]
                    : null,
                padding: EdgeInsets.symmetric(vertical: 0),
                spaceBetween: 10,
                radioRadius: 10,
                color: kPrimaryColor,
                onChanged: (listIndex) {
                  widget.onSelect(listIndex.toString());
                },
                type: widget.type,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
