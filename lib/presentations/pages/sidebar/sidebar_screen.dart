import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sidebar/drawer_body.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SidebarScreen extends StatelessWidget {
  const SidebarScreen({Key? key, this.user, this.voucherCount, this.newsCount})
      : super(key: key);

  final User? user;
  final int? voucherCount;
  final int? newsCount;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Container(
        color: kPrimaryColor,
        child: user != null
            ? DrawerBody(
                user: user, voucherCount: voucherCount, newsCount: newsCount)
            : _defaultDrawer(context),
      ),
    );
  }

  _defaultDrawer(BuildContext context) {
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              kMaterialAppTitle,
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/signin');
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
                          onTap: () => Navigator.pushNamed(context, '/signin'),
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        newsCount != 0
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
                        newsCount != 0
                            ? SizedBox(
                                height: 20,
                              )
                            : Container(),
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
}
