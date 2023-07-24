import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class CheckboxCard extends StatefulWidget {
  const CheckboxCard({Key? key}) : super(key: key);

  @override
  _CheckboxCardState createState() => _CheckboxCardState();
}

class _CheckboxCardState extends State<CheckboxCard> {
  Map<String, dynamic> values = {
    'ပုဇွန်': false,
    'ပြည်ကြီးငါး': false,
    'ငါးဖယ်': false
  };

  var addon_price = 1000;
  var total = 4500;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose of Add on',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: values.keys.map(
                (String key) {
                  return InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 3),
                            title: Text(key),
                            value: values[key],
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (dynamic value) {
                              setState(
                                () {
                                  values[key] = value;
                                  if (value) {
                                    total += addon_price;
                                  } else {
                                    total -= addon_price;
                                  }
                                },
                              );
                            },
                            activeColor: kPrimaryColor,
                          ),
                        ),
                        Text('+ $addon_price'),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
