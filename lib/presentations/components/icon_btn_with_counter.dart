import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:flutter/material.dart';

class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    Key? key,
    required this.svgSrc,
    this.numOfitem = 0,
    required this.press,
  }) : super(key: key);

  final Widget svgSrc;
  final int numOfitem;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: press,
      child: Stack(
        // overflow: Overflow.visible,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: kButtonBackgroundColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: svgSrc,
          ),
          if (numOfitem != 0)
            Positioned(
              top: -4,
              right: 0,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfitem",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10, context),
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
