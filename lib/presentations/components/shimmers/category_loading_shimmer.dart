import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesLoadingListPage extends StatefulWidget {
  @override
  _CategoriesLoadingListPageState createState() =>
      _CategoriesLoadingListPageState();
}

class _CategoriesLoadingListPageState extends State<CategoriesLoadingListPage> {
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
            child: _categorySkeleton(context),
          ),
        ],
      ),
    );
  }

  _categorySkeleton(context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 115,
      child: ListView.builder(
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SizedBox(
            width: getProportionateScreenWidth(55, context),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        color: kButtonBackgroundColor.withOpacity(0.5)),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: 60,
                  height: 8.0,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  width: 50,
                  height: 8.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        itemCount: 20,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
