import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  CategoryItem({
    Key? key,
    required this.category,
  }) : super(key: key);
  final Category category;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  void initState() {
    super.initState();
  }

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
                height: 120,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.category.image!,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            child: Text(
              widget.category.category!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
