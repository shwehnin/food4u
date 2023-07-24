import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/carts/carts_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/cart.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/check_out/check_out_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/cart/cart_list.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, required this.isShowbackButton})
      : super(key: key);

  final bool isShowbackButton;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartsBloc _cartsBloc;
  List<FoodCart> cartList = [];

  int total = 0;
  String token = '';
  Company? _company;
  bool _isGotoCheckOut = false;

  void initState() {
    super.initState();
    _cartsBloc = BlocProvider.of<CartsBloc>(context);
    _getUserValues();
    _getCompanyValues();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<CartsBloc, CartsState>(builder: (context, state) {
        if (state is CartsInitialState || state is CartDeleteLoadingState) {
          //EasyLoading.show(status: LocaleKeys.loading.tr());
          //return CartListLoading();
        }

        if (state is CartFailureState) {
          EasyLoading.dismiss();
          var message = state.message.toString().replaceAll('Exception: ', '');
          showErrorMessage(message);
          if (message.toString() == 'Unauthenticated.') {
            _signOutAccount();
          }
        }

        if (state is CartUpdateLoadingState) {
          return Container();
        }

        if (state is CartLoadingSuccessState) {
          //EasyLoading.dismiss();

          if (state.carts['cart_item'] != null) {
            cartList = List<FoodCart>.from(state.carts['cart_item']
                .map((i) => FoodCart.fromCartList(i))).toList();

            Map lists = state.carts;

            _deliveryFormat() {
              if (lists['est_deli_time'] > 24) {
                return Text(
                  '${lists['est_deli_time'] / 24}' + ' $deliveryDayText',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                );
              } else if (lists['est_deli_time'] > 365) {
                return Text(
                  '${lists['est_deli_time'] / 365}' + ' $deliveryYearText',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                );
              } else {
                return Text('${lists['est_deli_time'].toString()}' +
                    '$deliveryTimeText');
              }
            }

            return Scaffold(
              backgroundColor: kPrimaryLightColor,
              body: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.isShowbackButton
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: CustomAppBar(
                                leading: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  color:
                                      kButtonBackgroundColor.withOpacity(0.1),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    _cartsBloc..add(InitialCartRequested());
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/Back ICon.svg",
                                    height: 15,
                                  ),
                                ),
                                title: cartList.length > 0
                                    ? '${LocaleKeys.my_cart.tr()} (${_getCartItemCounts()} items)'
                                    : '${LocaleKeys.my_cart.tr()} ',
                                action: [],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, left: 10.0),
                              child: Text(
                                cartList.length > 0
                                    ? '${LocaleKeys.my_cart.tr()} (${_getCartItemCounts()} items)'
                                    : '${LocaleKeys.my_cart.tr()} ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                      // CartList(
                      //   isRemove: false,
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: CartList(
                          cartList: cartList,
                          isRemove: false,
                          token: token,
                          logo: _company != null ? _company!.logo! : '',
                        ),
                      ),
                      // TotalCalc(),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          children: [
                            lists['discount_amount'] != 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          LocaleKeys.discount_amount.tr(),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          getCurrencyFormat(
                                              'K', lists['discount_amount']),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: DottedLine(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.sub_total.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  getCurrencyFormat('K', lists['sub_total']),
                                  //'${NumberFormat.decimalPattern().format(calculateSubtotalAmount(cartList))}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            lists['delivery_fee'] != 0 &&
                                    lists['delivery_fee'] != null
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          LocaleKeys.delivery_fee.tr(),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          getCurrencyFormat(
                                              'K', lists['delivery_fee']),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.tax_amount.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  getCurrencyFormat('K', lists['tax_amount']),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    HeroIcon(
                                      HeroIcons.truck,
                                      color: Colors.black,
                                      solid: true,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    _deliveryFormat(),
                                    // Text(
                                    //   '${double.parse(lists['est_deli_time'].toString())} $deliveryTimeText',
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                                Text(
                                  LocaleKeys.grand_total.tr(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    getCurrencyFormat(
                                        'K', lists['grand_total']),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      BlocConsumer<ProfileBloc, ProfileState>(
                        builder: (BuildContext context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: MaterialButton(
                                color: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: () {
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    ProfileRequested(
                                        token: token, isFirstTime: true),
                                  );
                                },
                                child: Text(
                                  'Go to checkout',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                        listener: (BuildContext context, state) {
                          if (state is ProfileLoadSuccess) {
                            _cartsBloc..add(InitialCartRequested());

                            if (!_isGotoCheckOut) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CheckoutScreen(
                                            cartList: cartList,
                                            token: token,
                                            hours: double.parse(
                                                lists['est_deli_time']
                                                    .toString()),
                                            logo: _company != null
                                                ? _company!.logo!
                                                : '',
                                          )));
                            }
                            setState(() {
                              _isGotoCheckOut = true;
                            });
                          }
                          if (state is ProfileLoadFailure) {
                            var message = state.message
                                .toString()
                                .replaceAll('Exception: ', '');
                            showErrorMessage(message);
                            if (message.toString() == 'Unauthenticated.') {
                              _signOutAccount();
                            }
                          }
                        },
                      )

                      // CheckoutBtn(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return _emptyCartScaffold;
          }
        }
        return Container();
      }, listener: (context, state) {
        if (state is VoucherVerifyLoadFailure) {
          //return CartListLoading();
          EasyLoading.show(status: LocaleKeys.loading.tr());
        }

        if (state is CartUpdateLoadingState) {
          EasyLoading.show(status: LocaleKeys.loading.tr());
          _cartsBloc.add(
            CartListRequested(token: token),
          );
        }

        if (state is CartUpdateLoadingSuccess) {
          _cartsBloc.add(
            CartListRequested(token: token),
          );
        }

        if (state is CartLoadingSuccessState) {
          //EasyLoading.dismiss();

          if (state.carts['cart_item'] != null) {
            setState(() {
              cartList = List<FoodCart>.from(state.carts['cart_item']
                  .map((i) => FoodCart.fromCartList(i))).toList();
            });
          }
        }

        if (state is CartDeleteLoadingState) {
          EasyLoading.show(status: LocaleKeys.loading.tr());
        }
      }),
    );
  }

  get _emptyCartScaffold {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.isShowbackButton
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomAppBar(
                        leading: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          color: kButtonBackgroundColor.withOpacity(0.1),
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            "assets/icons/Back ICon.svg",
                            height: 15,
                          ),
                        ),
                        title: '${LocaleKeys.my_cart.tr()} (0 item)',
                        action: [],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomAppBar(
                        title: '${LocaleKeys.my_cart.tr()}  (0 item)',
                        action: [],
                      ),
                    ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/icons/cart.json',
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Text(
                        LocaleKeys.your_cart_is_empty.tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Text(
                          LocaleKeys.load_up_that_basket.tr(),
                          style: TextStyle(
                            color: kPrimaryLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUserValues() async {
    User? userValue = await _readUserValue();
    if (userValue != null) {
      setState(() {
        token = userValue.token!;
      });
      _cartsBloc.add(
        CartListRequested(token: token),
      );
    } else {
      setState(() {
        token = '';
      });
    }
  }

  Future<User?> _readUserValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      var user = User.fromSharePreJson(json.decode(prefs.getString('user')!));
      return user;
    } else {
      return null;
    }
  }

  Future<void> _signOutAccount() async {
    showErrorMessage('Unauthenticated.');

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushReplacementNamed(context, '/home');
  }

  _getCartItemCounts() {
    int _dataCount = 0;
    for (int i = 0; i < cartList.length; i++) {
      _dataCount += cartList[i].orderQuantity;
    }
    return _dataCount;
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
}
