import 'package:bestcannedfood_ecommerce/blocs/categories/categories_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sub_categories/sub_categories_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/category/category_item.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key, this.category}) : super(key: key);

  final String? category;

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late CategoriesBloc _categoriesBloc;
  List<Category> _data = [];

  @override
  void initState() {
    super.initState();
    _initializedBloc();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return _searchFilterScaffold;
        } else {
          return NoInternetWidget();
        }
      },
    );
  }

  get _searchFilterScaffold {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                    title: '${LocaleKeys.category.tr()} (${_data.length})',
                    titleColor: kHeadingColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                BlocConsumer<CategoriesBloc, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesListLoadSuccess) {
                      // Show only first time loading
                      EasyLoading.dismiss();
                      _data = state.categoriesList;

                      //CategoryItem
                      return _data.length > 0
                          ? Container(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: MediaQuery.of(context)
                                              .orientation ==
                                          Orientation.landscape
                                      ? 1
                                      : MediaQuery.of(context).size.width > 500
                                          ? 1
                                          : 0.7,
                                ),
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    // onTap: () => _gotoSearchItemsScreen(
                                    //     context, _data[index].toString()),
                                    onTap: () => navigateToSubCategoriesPage(
                                        context, _data[index]),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child:
                                          CategoryItem(category: _data[index]),
                                    ),
                                  );
                                },
                                itemCount: _data.length,
                              ),
                            )
                          : _getEmptySearch;
                    }

                    if (state is CategoriesListLoadFailure) {
                      EasyLoading.dismiss();
                    }
                    return Container();
                  },
                  listener: (context, state) {
                    if (state is CategoriesListLoadSuccess) {
                      setState(() {
                        _data = state.categoriesList;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _initializedBloc() {
    _categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    _categoriesBloc
      ..add(CategoriesListRequested(keyword: '', sort: '', order: ''));
  }

  Widget get _getEmptySearch {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/icons/noorder.json', repeat: true, height: 100),
          SizedBox(height: 10),
          Center(
            child: Text(
              LocaleKeys.not_found.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void navigateToSubCategoriesPage(BuildContext context, Category category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SubCategoriesScreen(category: category);
    }));
  }
}
