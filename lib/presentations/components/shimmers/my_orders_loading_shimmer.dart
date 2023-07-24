import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyOrdersLoadingPage extends StatefulWidget {
  @override
  _MyOrdersLoadingPageState createState() => _MyOrdersLoadingPageState();
}

class _MyOrdersLoadingPageState extends State<MyOrdersLoadingPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: _getAppbarSection,
              ),
              Padding(
                // 4 Tabs
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _tabsSkeleton,
              ),
              Padding(
                // My Orders list
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _myOrdersSkeleton(context, size),
              ),
            ]),
          ),
        ],
      )),
    );
  }

  get _getAppbarSection {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        color: kButtonBackgroundColor.withOpacity(0.5)),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: kButtonBackgroundColor.withOpacity(0.5)),
                    ),
                    child: _myOrdersTitle),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 2, color: kButtonBackgroundColor.withOpacity(0.5)),
          ),
          child: CircleAvatar(
            radius: 20,
          ),
        ),
      ],
    );
  }

  get _myOrdersTitle {
    return Container(
      width: 200,
      color: Colors.white,
    );
  }

  get _tabsSkeleton {
    return Container(
      height: 50,
      color: Colors.white,
    );
  }

  _myOrdersSkeleton(context, size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 1000,
      child: ListView.builder(
        itemBuilder: (_, __) => SizedBox(
          width: getProportionateScreenWidth(140, context),
          child: Container(
            //padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // date Textbox
                      _firstDateSkeleton,
                      // Status Textbox
                      _statusSkeleton,
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, bottom: 10.0, top: 10.0),
                  // second date Textbox
                  child: _secondDateSkeleton,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // date Textbox
                    _totalKyatSkeleton,
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
        itemCount: 10,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  get _firstDateSkeleton {
    return Container(
      width: 170,
      height: 25,
      color: Colors.white,
    );
  }

  get _secondDateSkeleton {
    return Container(
      width: 160,
      height: 10,
      color: Colors.white,
    );
  }

  get _statusSkeleton {
    return Container(
      width: 120,
      height: 30,
      color: Colors.white,
    );
  }

  get _totalKyatSkeleton {
    return Container(
      width: 170,
      height: 10,
      color: Colors.white,
    );
  }
}
