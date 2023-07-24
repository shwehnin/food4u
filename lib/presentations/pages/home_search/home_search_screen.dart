import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/categories/categories_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/foods/foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/latest_food.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key, this.category}) : super(key: key);

  final String? category;

  @override
  _HomeSearchScreenState createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  bool isShowFiler = false;
  int _count = 0;
  var _category = '';
  var _size = '';
  var _spicy_level = '';
  var _sort = LocaleKeys.date.tr();
  String _token = '';
  String _keyword = '';
  String _sortKey = 'updated_at';
  String _sortValue = 'DESC';
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  var _subCategory = '';
  int _page = 1;
  List<FoodMaster> foodMaster = [];

  List<String> _sizeList = [
    "House cleaning",
    "Ironing and Folding",
    "Dry cleaning",
    "Cloth wash"
  ];

  List<String> _spicyList = ['အချို', 'အစပ်', 'ပုံမှန်'];

  List<String> _categoriesList = [];

  /*
  List<String> _others = [
    "Instock",
    "Make Preorder",
  ];*/

  List<String> _sortList = [
    LocaleKeys.low_price.tr(),
    LocaleKeys.high_price.tr(),
    LocaleKeys.date.tr(),
    LocaleKeys.rating.tr()
  ];

  List<String> _sortKeyList = [
    "unit_price",
    "unit_price",
    "updated_at",
    "total_stars"
  ];

  List<String> _sortValueList = ["ASC", "DESC", "DESC", "DESC"];

  late FoodsBloc _foodsBloc;
  late CategoriesBloc _categoriesBloc;
  String _title = '';
  Company? _company;
  String _onBackPressed = '';

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      List<String> data =
          ModalRoute.of(context)!.settings.arguments as List<String>;
      setState(() {
        _category = data[0].toString();
        _token = data[1].toString();
        _keyword = data[2].toString();
        _title = data[3].toString();
        _onBackPressed = data[4].toString();
      });
      _initializedBloc();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _initializedBloc();
    _getCompanyValues();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return LazyLoadScrollView(
              child: _searchFilterScaffold, onEndOfPage: () => loadMore());
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
                      onPressed: () {
                        if (_onBackPressed == 'home') {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/icons/Back ICon.svg",
                        height: 15,
                      ),
                    ),
                    action: [
                      MaterialButton(
                        minWidth: 40,
                        height: 40,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        color: kButtonBackgroundColor.withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _categoriesBloc =
                              BlocProvider.of<CategoriesBloc>(context);
                          _categoriesBloc
                            ..add(CategoriesListRequested(
                                keyword: '', sort: '', order: ''));
                          showMaterialModalBottomSheet(
                              enableDrag: true,
                              context: context,
                              isDismissible: true,
                              expand: true,
                              backgroundColor: kPrimaryLightColor,
                              builder: (context) => _getFilterSection(
                                  ModalScrollController.of(context)));
                        },
                        child: HeroIcon(
                          HeroIcons.filter,
                          size: 18,
                        ),
                      )
                    ],
                    title: _title != ''
                        ? _title.toString()
                        : 'Search result ($_count items)',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                BlocConsumer<FoodsBloc, FoodsState>(
                  builder: (context, state) {
                    if (state is FoodsListLoadSuccess) {
                      // Show only first time loading

                      List<FoodMaster> list = List<FoodMaster>.from(state
                          .foodsList['data']
                          .map((i) => FoodMaster.fromFoodMasterList(i)));

                      return list.length > 0
                          ? LatestFoodSection(
                              foodsList: list,
                              token: _token,
                              type: 'search',
                              logo: _company != null ? _company!.logo! : '',
                            )
                          : _getEmptySearch;
                    }

                    if (state is FoodsListLoadFailure) {
                      EasyLoading.dismiss();
                    }
                    return Container();
                  },
                  listener: (context, state) {
                    if (state is FoodsListLoadInProgress) {
                      // Show only first time loading
                      EasyLoading.show(status: LocaleKeys.loading.tr());
                    }

                    if (state is FoodsListLoadSuccess) {
                      // Show only first time loading
                      EasyLoading.dismiss();
                      List<FoodMaster> list = List<FoodMaster>.from(state
                          .foodsList['data']
                          .map((i) => FoodMaster.fromFoodMasterList(i)));
                      setState(() {
                        _count = list.length;
                      });
                    }
                    if (state is LatestFoodsListLoadSuccess) {
                      EasyLoading.dismiss();
                      _foodListRequested();
                    }
                    if (state is FoodAddToFavouriteLoadSuccess) {
                      _foodListRequested();
                      showFavouriteSnackbar(state.message, context, _token);
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

  _getFilterSection(ScrollController? controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.category.tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            BlocConsumer<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: GroupButton(
                    borderRadius: BorderRadius.circular(30.0),
                    isRadio: true,
                    spacing: 10,
                    selectedColor: kBlackColor,
                    selectedButton: _category != ''
                        ? _categoriesList
                            .indexWhere((item) => item.contains(_category))
                        : -1,
                    mainGroupAlignment: MainGroupAlignment.start,
                    onSelected: (index, isSelected) {
                      setState(() {
                        _category = _categoriesList[index];
                      });
                      Navigator.of(context).pop();
                      _foodListRequested();
                    },
                    buttons: _categoriesList,
                  ),
                );
              },
              listener: (context, state) {
                if (state is CategoriesListLoadSuccess) {
                  // Show only first time loading
                  setState(() {
                    List<Category> _data = state.categoriesList;
                    for (int i = 0; i < _data.length; i++) {
                      if (!_categoriesList
                          .contains(_data[i].category.toString())) {
                        _categoriesList.add(_data[i].category.toString());
                      }
                    }
                  });
                }
              },
            ),
            _spicy_level != ''
                ? Text(
                    LocaleKeys.spicy_level.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                : Container(),
            _spicy_level != ''
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: GroupButton(
                      borderRadius: BorderRadius.circular(30.0),
                      isRadio: true,
                      spacing: 10,
                      selectedColor: kBlackColor,
                      mainGroupAlignment: MainGroupAlignment.start,
                      onSelected: (index, isSelected) => setState(() {
                        _spicy_level = _spicyList[index];
                        Navigator.of(context).pop();
                        _foodListRequested();
                      }),
                      buttons: _spicyList,
                    ),
                  )
                : Container(),
            Text(
              LocaleKeys.price.tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _minPrice('Min', true)),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _maxPrice('Max', false)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: kPrimaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                  _foodListRequested();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Set',
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              LocaleKeys.sort_by.tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: GroupButton(
                borderRadius: BorderRadius.circular(30.0),
                isRadio: true,
                spacing: 10,
                selectedColor: kBlackColor,
                selectedButton:
                    _sortList.indexWhere((item) => item.contains(_sort)),
                mainGroupAlignment: MainGroupAlignment.start,
                onSelected: (index, isSelected) => setState(() {
                  _sort = _sortList[index];
                  _sortKey = _sortKeyList[index];
                  _sortValue = _sortValueList[index];
                  Navigator.of(context).pop();
                  _foodListRequested();
                }),
                buttons: _sortList,
              ),
            ),
            SizedBox(height: 300),
          ],
        ),
      ),
    );
  }

  Widget _minPrice(String hintText, bool isMinPrice) {
    return TextField(
      cursorColor: kPrimaryColor,
      controller: _minPriceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _maxPrice(String hintText, bool isMinPrice) {
    return TextField(
      controller: _maxPriceController,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  _initializedBloc() {
    _foodsBloc = BlocProvider.of<FoodsBloc>(context);
    _foodListRequested();
  }

  _foodListRequested() {
    _foodsBloc
      ..add(FoodsListRequested(
          category: _category,
          subCategory: _subCategory,
          size: _size,
          spicyLevel: _spicy_level,
          minPrice: _minPriceController.text.toString(),
          maxPrice: _maxPriceController.text.toString(),
          keyword: _keyword,
          sort: _sortKey,
          order: _sortValue,
          paginate: 20,
          page: _page,
          isFirstTime: true,
          token: _token));
  }

  _getCompanyValues() async {
    Company? value = await _readCompanyValue();
    if (value != null) {
      setState(() {
        _company = value;
      });
    }
  }

  Future<Company?> _readCompanyValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('company') != null) {
      var _company =
          Company.fromCompanyList(json.decode(prefs.getString('company')!));
      return _company;
    } else {
      return null;
    }
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

  ///TO DO
  loadMore() {
    print("Page count ${_page += 1}");
    setState(() {
      _page += 1;
      // _foodListRequested();
    });
  }
}
