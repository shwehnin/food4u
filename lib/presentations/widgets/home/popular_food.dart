import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/popular_food_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PopularFoodList extends StatefulWidget {
  PopularFoodList(
      {Key? key,
      required this.foodsList,
      required this.token,
      required this.logo})
      : super(key: key);
  List<FoodMaster> foodsList = [];
  String token;
  String logo;

  @override
  _PopularFoodListState createState() => _PopularFoodListState();
}

class _PopularFoodListState extends State<PopularFoodList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.foodsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () => Navigator.pushReplacementNamed(
                    context, '/product_detail',
                    arguments: widget.foodsList[index]),
                child: PopularFoodItem(
                    token: widget.token,
                    foodMaster: widget.foodsList[index],
                    logo: widget.logo),
              ),
            );
          }),
    );
  }
}
