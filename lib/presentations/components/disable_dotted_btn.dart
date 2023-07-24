import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DisableDottedBtn extends StatefulWidget {
  const DisableDottedBtn({Key? key}) : super(key: key);

  @override
  _DisableDottedBtnState createState() => _DisableDottedBtnState();
}

class _DisableDottedBtnState extends State<DisableDottedBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 3,
        dashPattern: [10, 6],
        child: ClipRRect(
          child: Container(
            width: 210,
            height: 40,
            child: MaterialButton(
              // color: Colors.white60,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _getDialog(context),
                );
              },
              child: Text(
                LocaleKeys.your_voucher_code_is.tr(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController _discountCodeController = TextEditingController();

  AlertDialog _getDialog(context) {
    return AlertDialog(
      title: Text(LocaleKeys.your_voucher_code_is.tr()),
      content: TextFormField(
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        controller: _discountCodeController,
      ),
      actions: [
        MaterialButton(
          color: kPrimaryColor,
          onPressed: () {
            var discount_code = _discountCodeController.text;
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(color: kPrimaryLightColor),
          ),
        )
      ],
    );
  }
}
