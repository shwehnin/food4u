import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/forgot_password/forgot_password_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/otp/otp_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotOtpScreen extends StatefulWidget {
  ForgotOtpScreen(
      {Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);
  late String verificationId;
  final String phoneNumber;

  @override
  _ForgotOtpScreenState createState() => _ForgotOtpScreenState();
}

class _ForgotOtpScreenState extends State<ForgotOtpScreen> {
  bool isTimeUp = false;
  double time = 60.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => _backPressed(),
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),
          ],
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
          height: 390,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                              color: kPrimaryColor,
                              padding: EdgeInsets.zero,
                              onPressed: () => _backPressed(),
                              child: HeroIcon(
                                HeroIcons.chevronLeft,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            LocaleKeys.otp_verification.tr(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${LocaleKeys.we_sent_to.tr()} ${widget.phoneNumber}',
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
                    OtpForm(
                      routeName: '/forgot_change_password',
                      verificationId: widget.verificationId,
                      phoneNumber: widget.phoneNumber,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isTimeUp
                        ? GestureDetector(
                            onTap: () => _resentOtpCode(),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                              ),
                              child: Text(
                                LocaleKeys.resend_code_in.tr(),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
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
          style: TextStyle(fontSize: 18, color: kBlackColor),
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: time, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (context, value, child) {
            return Text(
              '${value.toString().split('.')[0]}s',
              style: TextStyle(fontSize: 18, color: kPrimaryColor),
            );
          },
          onEnd: () {
            setState(() {
              isTimeUp = true;
            });
          },
        ),
      ],
    );
  }

  _resentOtpCode() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      //await _auth.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      //showToast('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      showToast(LocaleKeys.sent_sms.tr());

      widget.verificationId = verificationId;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotOtpScreen(
                phoneNumber: widget.phoneNumber,
                verificationId: verificationId)),
      );
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      widget.verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: getPhoneNumberWithCountryCodeFormat(widget.phoneNumber),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {}
  }

  _backPressed() {
    BlocProvider.of<UsersBloc>(context)..add(InitialLoginRequested());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }
}
