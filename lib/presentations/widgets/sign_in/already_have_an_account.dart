import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final VoidCallback press;

  const AlreadyHaveAnAccount({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.locale.toString() == 'en' && login
              ? 'Don\'t have an account? '
              : '',
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login
                ? LocaleKeys.sign_up.tr()
                : LocaleKeys.sign_in_to_account.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
