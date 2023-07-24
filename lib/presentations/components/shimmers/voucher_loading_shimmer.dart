import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VoucherLoadingPage extends StatefulWidget {
  @override
  _VoucherLoadingPageState createState() => _VoucherLoadingPageState();
}

class _VoucherLoadingPageState extends State<VoucherLoadingPage> {
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
                    Padding(
                      // App Bar
                      padding: EdgeInsets.zero,
                      child: _appBarSkeleton(size),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      // Vouchers list
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _voucherSkeleton(context, size),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _appBarSkeleton(size) {
    return Container(
      width: size.width,
      height: 50,
      color: Colors.white,
    );
  }

  _voucherSkeleton(context, size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 1000,
      child: ListView.builder(
        itemBuilder: (_, __) => SizedBox(
          width: getProportionateScreenWidth(140, context),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // left side Textboxes
                    Container(
                      width: size.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rewardSkeleton,
                          SizedBox(height: 10),
                          _strategySkeleton,
                          SizedBox(height: 10),
                          _startDateEndDateSkeleton,
                          SizedBox(height: 10),
                          _voucherCodeSkeleton,
                        ],
                      ),
                    ),
                    // image
                    _imageSkeleton(size),
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

  get _rewardSkeleton {
    return Container(
      width: 80,
      height: 20,
      color: Colors.white,
    );
  }

  get _strategySkeleton {
    return Container(
      width: 300,
      height: 25,
      color: Colors.white,
    );
  }

  get _startDateEndDateSkeleton {
    return Container(
      width: 200,
      height: 25,
      color: Colors.white,
    );
  }

  get _voucherCodeSkeleton {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
      width: 100,
      height: 50,
      color: Colors.white,
    );
  }

  _imageSkeleton(size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
      height: 75,
      width: 80,
      color: Colors.white,
    );
  }
}
