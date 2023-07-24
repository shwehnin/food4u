import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailLoadingPage extends StatefulWidget {
  @override
  _OrderDetailLoadingPageState createState() => _OrderDetailLoadingPageState();
}

class _OrderDetailLoadingPageState extends State<OrderDetailLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getAppBarSelection,
                  _sizedBox10,
                  _myordersHeaderSkeleton,
                  SizedBox(height: 20),
                  _salesDetailListSkeleton,
                  _sizedBox10,
                  _calculateAmountSkeleton,
                  _sizedBox30,
                  _calculateAmountSkeleton,
                  _sizedBox30,
                  _calculateAmountSkeleton,
                  _sizedBox30,
                  _calculateAmountSkeleton,
                  _sizedBox30,
                  _calculateAmountSkeleton,
                  _sizedBox30,
                  _calculateAmountSkeleton,
                  _sizedBox30,
                  _preferredTimeSkeleton,
                  _sizedBox30,
                  _specialInstructionSkeleton,
                  _sizedBox30,
                  _deliveryLocationSkeleton,
                  _sizedBox30,
                  _canceledMsgSkeleton,
                  _sizedBox30,
                  _downloadPdfSkeleton,
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  get _sizedBoxHeight20 {
    return SizedBox(
      height: 20,
    );
  }

  get _sizedBoxWidth20 {
    return SizedBox(
      width: 20,
    );
  }

  get _sizedBox10 {
    return SizedBox(
      height: 10,
    );
  }

  get _sizedBox30 {
    return SizedBox(
      height: 30,
    );
  }

  get _calculateAmountSkeleton {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _calculatedAmountLeftSkeleton,
        _calculatedAmountRightSkeleton,
      ],
    );
  }

  get _getAppBarSelection {
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
      height: 80,
      color: Colors.white,
    );
  }

  get _myordersHeaderSkeleton {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // xx orders
        Container(
          height: 10,
          width: 50,
          color: Colors.white,
        ),
        _sizedBoxHeight20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //salesOrderAutoinc
            Container(
              width: 150,
              height: 30,
              color: Colors.white,
            ),
            // status
            Container(
              width: 130,
              height: 30,
              color: Colors.white,
            ),
          ],
        ),
        _sizedBox10,
        //salesOrderDate
        Container(
          height: 10,
          width: 150,
          color: Colors.white,
        ),
      ],
    );
  }

  get _salesDetailListSkeleton {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image and orderQty column
        Column(
          children: [
            CircleAvatar(
              radius: 40,
            ),
          ],
        ),
        _sizedBoxWidth20,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Food name
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _foodNameSkeleton,
                ],
              ),
              _sizedBoxHeight20,
              _salesDetailInfo,
              _sizedBoxHeight20,
              _salesDetailInfo,
              _sizedBoxHeight20,
              _salesDetailInfo,
              _sizedBoxHeight20,
              _salesDetailInfo,
              _sizedBoxHeight20,
              _salesDetailInfo,
              _sizedBoxHeight20,
              _salesDetailInfo,
              _sizedBoxHeight20,
            ],
          ),
        ),
      ],
    );
  }

  get _salesDetailInfo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _detailInfoLeftSkeleton,
        _detailInfoRightSkeleton,
      ],
    );
  }

  get _foodNameSkeleton {
    return Container(
      width: 230,
      height: 40,
      color: Colors.white,
    );
  }

  get _detailInfoLeftSkeleton {
    return Container(
      width: 150,
      height: 10,
      color: Colors.white,
    );
  }

  get _detailInfoRightSkeleton {
    return Container(
      width: 100,
      height: 10,
      color: Colors.white,
    );
  }

  get _calculatedAmountLeftSkeleton {
    return Container(
      width: 130,
      height: 10,
      color: Colors.white,
    );
  }

  get _calculatedAmountRightSkeleton {
    return Container(
      width: 130,
      height: 10,
      color: Colors.white,
    );
  }

  get _preferredTimeSkeleton {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130,
          height: 10,
          color: Colors.white,
        ),
        _sizedBox10,
        Container(
          width: 200,
          height: 20,
          color: Colors.white,
        ),
      ],
    );
  }

  get _specialInstructionSkeleton {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 10,
          color: Colors.white,
        ),
        _sizedBox10,
        Container(
          height: 30,
          color: Colors.white,
        ),
      ],
    );
  }

  get _deliveryLocationSkeleton {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130,
          height: 10,
          color: Colors.white,
        ),
        _sizedBox10,
        Container(
          height: 50,
          color: Colors.white,
        ),
      ],
    );
  }

  get _canceledMsgSkeleton {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130,
          height: 10,
          color: Colors.white,
        ),
        _sizedBox10,
        Container(
          height: 50,
          color: Colors.white,
        ),
      ],
    );
  }

  get _downloadPdfSkeleton {
    return Container(
      height: 50,
      color: Colors.white,
    );
  }
}
