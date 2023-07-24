import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class SizeCard extends StatefulWidget {
  SizeCard({Key? key, required this.sizes, required this.onSelect})
      : super(key: key);
  final List<String> sizes;
  Function(String) onSelect;

  @override
  _SizeCardState createState() => _SizeCardState();
}

class _SizeCardState extends State<SizeCard> {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.sizes.length != 0 && widget.sizes.length != 1
        ? Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Service',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: GroupButton(
                      borderRadius: BorderRadius.circular(30.0),
                      isRadio: true,
                      spacing: 10,
                      selectedColor: kBlackColor,
                      mainGroupAlignment: MainGroupAlignment.start,
                      onSelected: (index, isSelected) =>
                          widget.onSelect(widget.sizes[index]),
                      buttons: widget.sizes,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
