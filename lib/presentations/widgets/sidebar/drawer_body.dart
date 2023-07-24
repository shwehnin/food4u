import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerBody extends StatefulWidget {
  const DrawerBody({Key? key, this.user, this.voucherCount, this.newsCount})
      : super(key: key);

  final User? user;
  final int? voucherCount;
  final int? newsCount;

  @override
  State<DrawerBody> createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  Company? _company;

  @override
  void initState() {
    _getCompanyValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 50, bottom: 30),
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _company != null
                          ? Image(
                              image: CachedNetworkImageProvider(
                                _company!.logo!,
                              ),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200,
                                      child: Text(
                                        kMaterialAppTitle,
                                        style: TextStyle(
                                            color: kWhiteColor, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _company != null
                                ? Container(
                                    width: 200,
                                    child: Text(
                                      _company!.companyName!,
                                      style: TextStyle(color: kWhiteColor),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                  widget.user != null
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  widget.user != null && widget.user!.customerName != ''
                      ? Text(
                          widget.user!.customerName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: kWhiteColor),
                        )
                      : Container(),
                  widget.user != null
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  widget.user != null &&
                          (widget.user!.phone.toString() != 'null' ||
                              widget.user!.email.toString() != 'null')
                      ? Text(
                          widget.user!.phone.toString() != 'null'
                              ? widget.user!.phone
                              : widget.user!.email,
                          style: TextStyle(color: kWhiteColor),
                        )
                      : Container(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            widget.user != null
                                ? Navigator.pushNamed(context, '/my_order',
                                    arguments: widget.user!.token!)
                                : Navigator.pushNamed(context, '/signin');
                          },
                          child: Row(
                            children: [
                              HeroIcon(HeroIcons.cube, color: kWhiteColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                LocaleKeys.my_orders.tr(),
                                style: TextStyle(
                                  color: kWhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => _goToVoucherScreen(context),
                          child: Row(
                            children: [
                              HeroIcon(HeroIcons.ticket, color: kWhiteColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                LocaleKeys.vouchers.tr(),
                                style: TextStyle(color: kWhiteColor),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              widget.voucherCount != null &&
                                      widget.voucherCount != 0
                                  ? ClipOval(
                                      child: Container(
                                        color: kPrimaryLightColor,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          widget.voucherCount.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        widget.newsCount != 0
                            ? InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/new');
                                },
                                child: Row(
                                  children: [
                                    HeroIcon(HeroIcons.newspaper,
                                        color: kWhiteColor),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.news.tr(),
                                      style: TextStyle(color: kWhiteColor),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),

                        widget.newsCount != 0
                            ? SizedBox(
                                height: 20,
                              )
                            : Container(),

                        ///TODO
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          child: Row(
                            children: [
                              HeroIcon(HeroIcons.cog, color: kWhiteColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Settings',
                                style: TextStyle(color: kWhiteColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: kPrimaryColor,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Positioned(
                left: 0.0,
                bottom:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 25.0
                        : 50.0,
                child: _signOutSection),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Text(
                'Copyright \u00a9 2022 | bizzsync',
                style: TextStyle(color: kWhiteColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  get _signOutSection {
    return widget.user != null && widget.user!.token != null
        ? BlocConsumer<UsersBloc, UsersState>(builder: (context, state) {
            return InkWell(
              onTap: () {
                BlocProvider.of<UsersBloc>(context)
                  ..add(UserLogoutRequested(token: widget.user!.token!));
              },
              child: Row(
                children: [
                  HeroIcon(HeroIcons.logout, color: kWhiteColor),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.sign_out.tr(),
                    style: TextStyle(color: kWhiteColor),
                  ),
                ],
              ),
            );
          }, listener: (context, state) {
            if (state is UserLogoutLoadSuccess) {
              EasyLoading.showSuccess(LocaleKeys.sign_out_successfully.tr(),
                  duration: Duration(milliseconds: 5000));
              _signOutAccount();
              Navigator.pushReplacementNamed(context, '/home');
            }
          })
        : Container();
  }

  _signOutAccount() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('user');
  }

  _goToVoucherScreen(context) {
    if (widget.user != null) {
      Navigator.pushNamed(context, '/coupon', arguments: widget.user!.token!);
    } else {
      Navigator.pushNamed(context, '/signin');
    }
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
