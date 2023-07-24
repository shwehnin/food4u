import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingPage extends StatefulWidget {
  @override
  _ProfileLoadingPageState createState() => _ProfileLoadingPageState();
}

class _ProfileLoadingPageState extends State<ProfileLoadingPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: ListView(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _appbarSkeleton(size),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        // Delivery Location
                        child: _deliveryLocationSkeleton,
                      ),
                      Padding(
                        // Personal Profile
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _personalProfileSkeleton,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        // My Orders list
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _recentOrdersSkeleton,
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  _appbarSkeleton(size) {
    return Container(
      width: size.width,
      height: 30,
      color: Colors.white,
    );
  }

  get _deliveryLocationSkeleton {
    return Column(
      children: [
        // Title
        Container(
          padding: const EdgeInsets.only(left: 4.0),
          height: 30,
          color: Colors.white,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(left: 4.0),
          height: 70,
          color: Colors.white,
        ),
      ],
    );
  }

  get _personalProfileSkeleton {
    return Column(
      children: [
        // Title
        Container(
          padding: const EdgeInsets.only(left: 4.0),
          height: 30,
          color: Colors.white,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(left: 4.0),
          height: 190,
          color: Colors.white,
        ),
      ],
    );
  }

  get _recentOrdersSkeleton {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 30,
              width: 150,
              color: Colors.white,
            ),
            Container(
              height: 30,
              width: 100,
              color: Colors.white,
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          height: 1000,
          child: ListView.builder(
            itemBuilder: (_, __) => SizedBox(
              width: getProportionateScreenWidth(140, context),
              child: Container(
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
        ),
      ],
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
