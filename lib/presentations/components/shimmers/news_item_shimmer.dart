import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewItemShimmer extends StatefulWidget {
  @override
  _NewItemShimmerState createState() => _NewItemShimmerState();
}

class _NewItemShimmerState extends State<NewItemShimmer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: _newsRoomSkeleton(context),
          ),
        ],
      ),
    );
  }

  get _newsRoomSkeleton {
    return Container(
      width: double.infinity,
      height: 200.0,
      color: Colors.white,
    );
  }
}
