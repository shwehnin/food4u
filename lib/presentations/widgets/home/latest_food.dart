import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/latest_food_item.dart';
import 'package:flutter/material.dart';

class LatestFoodSection extends StatefulWidget {
  LatestFoodSection(
      {Key? key,
      required this.foodsList,
      required this.token,
      required this.logo,
      required this.type})
      : super(key: key);
  final List<FoodMaster> foodsList;
  final String token;
  final String logo;
  final String type;

  @override
  _LatestFoodSectionState createState() => _LatestFoodSectionState();
}

class _LatestFoodSectionState extends State<LatestFoodSection> {
  int _page = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // mainAxisSpacing: 20,
          mainAxisExtent: 250,
          childAspectRatio:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 1
                  : MediaQuery.of(context).size.width > 500
                      ? 1
                      : MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
        ),
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/product_detail',
                  arguments: widget.foodsList[index]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: LatestFoodItem(
                  foodMaster: widget.foodsList[index],
                  token: widget.token,
                  type: widget.type,
                  logo: widget.logo),
            ),
          );
        },
        itemCount: widget.foodsList.length,
      ),
    );
  }
}
