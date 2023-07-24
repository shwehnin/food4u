import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class GroupRadioButton extends StatefulWidget {
  GroupRadioButton(
      {required this.label,
      required this.padding,
      required this.onChanged,
      required this.type,
      this.color = Colors.blue,
      this.radioRadius = 12.0,
      this.spaceBetween = 5.0,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.subLabel,
      required this.labelTextList});

  final Color color;
  final List<Widget> label;
  final List<Widget>? subLabel;
  final EdgeInsets padding;
  final Function(int) onChanged;
  final double radioRadius;
  final double spaceBetween;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String type;
  final List<String> labelTextList;

  @override
  _GroupRadioButtonState createState() => _GroupRadioButtonState();
}

class _GroupRadioButtonState extends State<GroupRadioButton> {
  int selectedIndex = -1;
  final List<Widget> _labelList = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.label.length; i++) {
      if (!widget.label[i].toString().contains('null')) {
        _labelList.add(widget.label[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // ignore: unnecessary_null_comparison
        itemCount: _labelList != null ? _labelList.length : 0,
        itemBuilder: (context, index) {
          return widget.labelTextList[index] != null
              ? LabeledRadio(
                  selectedIndex: selectedIndex,
                  color: widget.color,
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value;
                      widget.onChanged(value);
                    });
                  },
                  index: index,
                  label: widget.label[index],
                  subLabel: widget.subLabel != null
                      ? widget.subLabel![index]
                      : Container(),
                  crossAxisAlignment: widget.crossAxisAlignment,
                  mainAxisAlignment: widget.mainAxisAlignment,
                  radioRadius: widget.radioRadius,
                  spaceBetween: widget.spaceBetween,
                  padding: widget.padding,
                  type: widget.type,
                  labelText: widget.labelTextList[index])
              : Container();
        });
  }
}

class LabeledRadio extends StatelessWidget {
  LabeledRadio(
      {required this.label,
      required this.index,
      required this.color,
      //@required this.groupValue,
      //@required this.value,
      required this.onChanged,
      required this.radioRadius,
      required this.padding,
      required this.spaceBetween,
      required this.mainAxisAlignment,
      required this.crossAxisAlignment,
      this.subLabel,
      this.selectedIndex,
      required this.type,
      required this.labelText});

  final Color color;
  final int? selectedIndex;
  final Widget label;
  final Widget? subLabel;
  final index;
  final EdgeInsets padding;
  //final bool groupValue;
  //final bool value;
  final Function(int) onChanged;
  final double radioRadius;
  final double spaceBetween;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String type;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(index);
      },
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                decoration: BoxDecoration(
                  //color: Const.mainColor,
                  shape: type != 'radio' ? BoxShape.rectangle : BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                padding:
                    type != 'radio' ? EdgeInsets.zero : EdgeInsets.all(2.0),
                child: selectedIndex == index
                    ? Container(
                        height: type != 'radio' ? radioRadius + 4 : radioRadius,
                        width: type != 'radio' ? radioRadius + 4 : radioRadius,
                        decoration: type != 'radio'
                            ? BoxDecoration(
                                color: color,
                              )
                            : BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                        child: type != 'radio'
                            ? HeroIcon(
                                HeroIcons.check,
                                size: 12,
                                color: kPrimaryLightColor,
                              )
                            : Container(),
                      )
                    : Container(
                        height: type != 'radio' ? radioRadius + 4 : radioRadius,
                        width: type != 'radio' ? radioRadius + 4 : radioRadius,
                      ),
              ),
            ),
            SizedBox(
              width: spaceBetween,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: label,
            ),
            Spacer(),
            subLabel!,
          ],
        ),
      ),
    );
  }
}
