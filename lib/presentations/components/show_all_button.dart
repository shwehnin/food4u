import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ShowAllButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ShowAllButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                LocaleKeys.show_all.tr(),
                style: TextStyle(color: kBlackColor),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: kBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}
