import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sub_categories/sub_categories_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/category_list.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatefulWidget {
  CategoryListWidget(
      {Key? key, required this.categoriesList, required this.token})
      : super(key: key);
  final List<Category> categoriesList;
  final String token;

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 140,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categoriesList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: GestureDetector(
                onTap: () => navigateToSubCategoriesPage(
                    context, widget.categoriesList[index]),
                child: CategoryList(
                  category: widget.categoriesList[index],
                  token: widget.token,
                ),
              ),
            );
          }),
    );
  }

  void navigateToSubCategoriesPage(BuildContext context, Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SubCategoriesScreen(category: category);
    }));
  }
}
