import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:timeline_tile/timeline_tile.dart';
// import 'package:timelines/timelines.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen(
      {Key? key,
      required this.trackingId,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.trackingData,
      required this.isFromSuccess})
      : super(key: key);
  final String trackingId;
  final String deliveryDate;
  final String deliveryTime;
  final List<dynamic> trackingData;
  final bool isFromSuccess;

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  List<String> statusList = [
    'Order Canceled!',
    'Order Received!',
    'Order Prepared!',
    'Order Picked Up!',
    'Order Delivered!'
  ];
  List<String> statusImagesList = [
    'assets/icons/canceled.json',
    'assets/icons/received.json',
    'assets/icons/prepared.json',
    'assets/icons/picked.json',
    'assets/icons/delivered.json'
  ];

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  leading: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    color: kButtonBackgroundColor.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (widget.isFromSuccess) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/icons/Back ICon.svg",
                      height: 15,
                    ),
                  ),
                  title: LocaleKeys.track_your_order.tr(),
                  action: [],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(LocaleKeys.tracking_order.tr()),
                Text(
                  widget.trackingId.toString(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getDeliveryDateTime(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.estimate_time_delivery.tr(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                _getStatusContainer(),
                SizedBox(
                  height: 20,
                ),
                customOrderTimeLine(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customOrderTimeLine() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      padding: EdgeInsets.only(
        top: 30,
        // left: 20,
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < widget.trackingData.length; i++)
            _timelineRow(
                widget.trackingData[i]['status'],
                _getOrderStatusDateFormat(
                    widget.trackingData[i]['date'].toString()),
                HeroIcon(
                  _getIcon(widget.trackingData[i]['status'].toString()),
                  color: kPrimaryLightColor,
                ),
                widget.trackingData[i]['status'].toString().contains('Canceled')
                    ? Colors.red
                    : kPrimaryColor),
        ],
      ),
    );
  }

  Widget _timelineRow(
      String title, String subTile, final icon, final Color backgroundColor) {
    return TimelineTile(
      alignment: TimelineAlign.start,

      indicatorStyle: IndicatorStyle(
        width: 25,
        color: kPrimaryLightColor,
        indicatorXY: 0.5,
        indicator: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              color: kPrimaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: kPrimaryLightColor, width: 3)),
        ),
      ),
      beforeLineStyle: const LineStyle(
        color: kPrimaryColor,
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: kPrimaryColor,
        thickness: 3,
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: icon,
                ),
                SizedBox(width: 10),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      subTile,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // startChild: Container(
      // ),
    );
  }

  _getStatusContainer() {
    int index = _getStringIndex(widget
        .trackingData[widget.trackingData.length - 1]['status']
        .toString());

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(statusImagesList[index],
              height: 300, width: MediaQuery.of(context).size.width),
          SizedBox(
            height: 10,
          ),
          Text(
            statusList[index],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          index == 4
              ? Text(
                  LocaleKeys.our_driver_delivered.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )
              : Container(),
        ],
      ),
    );
  }

  String _getDeliveryDateTime() {
    DateTime dateData = DateTime.parse(widget.deliveryDate.toString());
    String _day = DateFormat('E').format(dateData);
    String _dayType = dateData.day.toString();
    String data = '';

    for (int i = 0; i < timeDataList.length; i++) {
      if (widget.deliveryTime.toString() == timeDataList[i]) {
        data = '$_day, $_dayType ${timeNameList[i]}';
      }
    }
    return data;
  }

  HeroIcons _getIcon(String data) {
    if (data.contains('Order Received')) {
      return HeroIcons.shoppingBag;
    } else if (data.contains('Order Canceled')) {
      return HeroIcons.xCircle;
    } else if (data.contains('Prepared')) {
      return HeroIcons.hand;
    } else if (data.contains('Picked up')) {
      return HeroIcons.truck;
    } else {
      return HeroIcons.checkCircle;
    }
  }

  _getStringIndex(String data) {
    int index = 0;
    for (int i = 0; i < statusList.length; i++) {
      if (statusList[i]
          .toString()
          .toLowerCase()
          .replaceAll(" ", '')
          .contains(data.toLowerCase().replaceAll(" ", ''))) {
        index = i;
      }
    }
    return index;
  }

  _getOrderStatusDateFormat(String data) {
    DateTime dateData = DateTime.parse(data);
    return DateFormat().format(dateData);
  }
}
