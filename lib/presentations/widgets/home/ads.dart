import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:flutter/material.dart';

class Ads extends StatelessWidget {
  final String image;
  const Ads({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => launchURL('https://phwephwe.bizzsync.app/'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          width: size.width,
          height: MediaQuery.of(context).orientation == Orientation.landscape &&
                  MediaQuery.of(context).size.width > 500
              ? 250
              : 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
