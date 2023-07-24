import 'package:bestcannedfood_ecommerce/presentations/components/custom_full_btn.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DisableBtn extends StatelessWidget {
  const DisableBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 43,
      child: MaterialButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 150,
                  child: _buildCheckoutTotal(),
                );
              });
        },
        child: Text(
          'APPLY',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCheckoutTotal() {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.total.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '7,450 K',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFullBtn(btnName: 'ORDER NOW'),
          )
        ],
      ),
    );
  }
}
