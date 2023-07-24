import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final Category category;
  final String token;

  const CategoryList({Key? key, required this.category, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 2, color: kButtonBackgroundColor.withOpacity(0.5)),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: kButtonBackgroundColor.withOpacity(0.5),
              backgroundImage: CachedNetworkImageProvider(category.image!),
            ),
          ),
          SizedBox(height: 15),
          Text(
            category.category!,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(height: 1.5),
          )
        ],
      ),
      // ),
    );
  }

  _gotoSearchItemsScreen(BuildContext context, String category) {
    List<String> arg = [category, token, '', '', 'home'];
    Navigator.pushReplacementNamed(context, '/search', arguments: arg);
  }
}
