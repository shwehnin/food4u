import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoadMore extends StatefulWidget {
  const LoadMore({Key? key}) : super(key: key);

  @override
  _LoadMoreState createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () {},
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          LocaleKeys.load_more.tr(),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
