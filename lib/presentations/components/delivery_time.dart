import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeliveryTime extends StatefulWidget {
  final double hours;
  DeliveryTime(
      {Key? key,
      required this.hours,
      required this.onDeliveryTime,
      required this.onDeliverDate})
      : super(key: key);

  Function(String) onDeliveryTime;
  Function(String) onDeliverDate;

  @override
  _DeliveryTimeState createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {
  int radioValue = -1;
  List<String> _dayList = [];

  int _selectedIndex = -1;

  int _selectedTimeIndex = -1;

  String date = '';
  String time = '';

  @override
  void initState() {
    super.initState();
    _initializeDateTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0, bottom: 10.0),
            child: Text(
              LocaleKeys.order_a_slot.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _getDaySlot,
          SizedBox(
            height: 10,
          ),
          _getTimeSlot,
        ],
      ),
    );
  }

  get _getDaySlot {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          DateTime dateData = DateTime.parse(_dayList[index]);
          String _day = DateFormat('E').format(dateData);
          String _dayType = dateData.day.toString();
          //print('daydata $_day $_dayType');
          return Container(
            width: (MediaQuery.of(context).size.width - 20) / 5,
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: MaterialButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: _selectedIndex == index
                    ? BorderSide(color: kBlackColor)
                    : BorderSide(color: Colors.grey.shade300),
              ),
              color:
                  _selectedIndex == index ? kPrimaryColor : kPrimaryLightColor,
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onDeliverDate(_dayList[_selectedIndex]);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _day,
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? kPrimaryLightColor
                          : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _dayType,
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? kPrimaryLightColor
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: _dayList.length,
      ),
    );
  }

  get _getTimeSlot {
    return Container(
      height: 140,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: RadioListTile(
              contentPadding: EdgeInsets.zero,
              value: index,
              groupValue: _selectedTimeIndex,
              onChanged: (ind) => setState(() {
                _selectedTimeIndex = int.parse(ind.toString());
                widget.onDeliveryTime(timeDataList[_selectedTimeIndex]);
              }),
              activeColor: kPrimaryColor,
              title: Text(
                timeNameList[index],
                style:
                    TextStyle(color: kBlackColor, fontWeight: FontWeight.w700),
              ),
            ),
          );
        },
        itemCount: timeNameList.length,
      ),
    );
  }

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

  void _initializeDateTimes() {
    List.generate(
        2,
        (index) =>
            _dayList.add(getOrderSlotDay(index, widget.hours).toString()));
  }
}



/*
                Container(
                  width: 150,
                  child: new DropdownButton<String>(
                    elevation: 2,
                    isExpanded: true,
                    icon: HeroIcon(
                      HeroIcons.chevronDown,
                      color: kPrimaryColor,
                      size: 14,
                    ),
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: <String>[
                      'Wed, Aug 4',
                      'Thur, Aug 5',
                      'Fri, Aug 6',
                      'Sat ,Aug 7'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    value: date,
                    onChanged: (value) {
                      setState(() {
                        date = value.toString();
                      });
                    },
                  ),
                ),
                Container(
                    height: 20,
                    width: 5,
                    child: VerticalDivider(color: Colors.black)),
                Container(
                  width: 150,
                  child: new DropdownButton<String>(
                    elevation: 2,
                    isExpanded: true,
                    icon: HeroIcon(
                      HeroIcons.chevronDown,
                      color: kPrimaryColor,
                      size: 14,
                    ),
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: <String>[
                      'ASAP',
                      '10:00 AM',
                      '10:15 AM',
                      '10:30 AM',
                      '10:45 AM',
                      '11:00 AM',
                      '11:15 AM',
                      '11:30 AM',
                      '11:45 AM',
                      '12:00 PM',
                      '12:15 AM',
                      '12:30 PM',
                      '12:45 PM',
                      '1:00 PM',
                      '1:15 PM',
                      '1:30 PM',
                      '1:45 PM',
                      '2:00 PM',
                      '2:15 PM',
                      '2:30 PM',
                      '2:45 PM',
                      '3:00 PM',
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    value: time,
                    onChanged: (value) {
                      setState(() {
                        time = value.toString();
                      });
                    },
                  ),
                ),*/
              