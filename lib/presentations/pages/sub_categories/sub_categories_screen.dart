import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bestcannedfood_ecommerce/blocs/sub_categories/sub_categories_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/model/sub_category.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sub_category/sub_category_item.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:lottie/lottie.dart';

class SubCategoriesScreen extends StatefulWidget {
  final Category? category;
  String? token;
  SubCategoriesScreen({
    this.token,
    this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() =>
      _SubCategoriesScreenState(category);
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final Category? category;
  _SubCategoriesScreenState(this.category);
  late SubCategoriesBloc _subCategoriesBloc;
  List<SubCategory> _data = [];
  final columns = 4;

  @override
  void initState() {
    super.initState();
    _subCategoriesBloc = BlocProvider.of<SubCategoriesBloc>(context);
    // Call API request to get Sub Categories list
    _subCategoriesBloc.add(
      SubCategoriesListRequested(
        categoryId: int.parse(category!.id.toString()),
        category: category!.category.toString(),
        sort: 'sub_category',
        order: 'ASC',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomAppBar(
                    leading: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      color: kButtonBackgroundColor.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      child: SvgPicture.asset(
                        "assets/icons/Back ICon.svg",
                        height: 15,
                      ),
                    ),
                    action: [],
                    title:
                        '${LocaleKeys.sub_categories.tr()} (${category!.category.toString()})',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildSubCategories()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategories() {
    final w = (MediaQuery.of(context).size.width - 4 * (columns - 1)) / columns;
    return BlocConsumer<SubCategoriesBloc, SubCategoriesState>(
      listener: (context, state) {
        if (state is SubCategoriesListLoadSuccess) {
          setState(() {
            _data = state.subCategoriesList;
          });
        }
      },
      builder: (context, state) {
        if (state is SubCategoriesListLoadSuccess) {
          _data = state.subCategoriesList;
          return _data.length > 0
              ? Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () => _gotoSubCategoryItemsScreen(
                          context,
                          category!.category.toString(),
                          _data[index].subCategory.toString(),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: SubCategoryItem(subCategory: _data[index]),
                        ),
                      );
                    },
                    itemCount: _data.length,
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/icons/noorder.json',
                          repeat: true, height: 100),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          LocaleKeys.not_found.tr(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
        }
        return Container();
      },
    );
  }

  _gotoSubCategoryItemsScreen(
      BuildContext context, String category, String subCategory) {
    List<String> arg = ['', '', '', 'back', category, subCategory];
    Navigator.pushNamed(context, '/subcategory_items', arguments: arg);
  }
}
