import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 35.0),
            child: Container(
              child: CustomAppBar(
                  leading: Container(
                    height: 40,
                    width: 40,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      color: kButtonBackgroundColor.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        "assets/icons/Back ICon.svg",
                        height: 15,
                      ),
                    ),
                  ),
                  title: '',
                  titleColor: kPrimaryLightColor,
                  action: []),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Lottie.asset(
                'assets/icons/network-error.json',
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
