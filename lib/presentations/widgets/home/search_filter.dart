import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
        color: kButtonBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Theme(
        child: TextField(
          onChanged: (value) => print(value),
          onSubmitted: (value) {
            List<String> arg = [
              '',
              widget.token,
              value,
              '',
              'home',
            ];
            Navigator.pushNamed(context, '/search', arguments: arg);
          },
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: LocaleKeys.search_for_anything.tr(),
              prefixIcon: Icon(Icons.search)),
        ),
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: kPrimaryColor,
              ),
        ),
      ),
    );
  }
}
