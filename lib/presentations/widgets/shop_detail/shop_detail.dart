import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class ShopDetail extends StatelessWidget {
  const ShopDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              'Yann Kyite (Sunshine Food Villa)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/images/burger.jpg',
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'No.39, (A-B), Than Thu Ma road, Thingangyun twp, Yangon, 11061',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '+959692215106, www.sunshinefoodvilla.com',
              style: TextStyle(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
