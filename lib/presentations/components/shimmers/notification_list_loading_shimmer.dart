import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationListLoading extends StatefulWidget {
  const NotificationListLoading({Key? key}) : super(key: key);

  @override
  _NotificationListLoadingState createState() =>
      _NotificationListLoadingState();
}

class _NotificationListLoadingState extends State<NotificationListLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleSkeleton,
                listSkeleton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  get _titleSkeleton {
    return Row(
      children: [
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
        SizedBox(width: 20),
        Container(
          width: 250,
          height: 10.0,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget listSkeleton() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: size.width - 40,
                height: 100,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 40.0,
                height: 8.0,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
