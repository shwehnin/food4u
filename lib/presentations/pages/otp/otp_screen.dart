import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/otp/otp_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: Container(
              height: getProportionateScreenWidth(40, context),
              width: getProportionateScreenWidth(40, context),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                color: kPrimaryLightColor,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                ),
              ),
            ),
          ),
          /*
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'ecommerce',
                          style: kHeading,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          splash_msg,
                          style: kbodyText1,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: kPrimaryLightColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        height: 350,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10
                    // topLeft: Radius.circular(20),
                    // topRight: Radius.circular(20),
                    ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          LocaleKeys.otp_verification.tr(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${LocaleKeys.we_sent_to.tr()} 09*********',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  buildTimer(),
                  SizedBox(
                    height: 50,
                  ),
                  OtpForm(routeName: '/home'),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.resend_code_in.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${LocaleKeys.code_expired_in.tr()} ',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(minutes: 1),
          builder: (context, value, child) {
            return Text(
              '${value.toString().split('.')[0]}s',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
              ),
            );
          },
        ),
      ],
    );
  }
}
