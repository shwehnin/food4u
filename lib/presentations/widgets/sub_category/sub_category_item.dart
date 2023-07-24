import 'package:flutter/material.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/sub_category.dart';

class SubCategoryItem extends StatefulWidget {
  final SubCategory subCategory;
  const SubCategoryItem({
    Key? key,
    required this.subCategory,
  }) : super(key: key);

  @override
  State<SubCategoryItem> createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<SubCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 40) / 3,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 60,
                width: 150,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    widget.subCategory.subCategory.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
