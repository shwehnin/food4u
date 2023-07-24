import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';

class NoInternetWidget extends StatefulWidget {
  NoInternetWidget({Key? key}) : super(key: key);

  @override
  _NoInternetWidgetState createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/icons/no-connection.json',
                  width: 300, height: MediaQuery.of(context).size.height / 3),
              Text(
                'Whoops',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                LocaleKeys.slow_connection.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                LocaleKeys.check_internet_setting.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ));
  }
}
