import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/phone_number/change_phone_number.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/change_phone/change_phone_otp_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sms_autofill/sms_autofill.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: must_be_immutable
class ChangePhoneOtpScreen extends StatefulWidget {
  ChangePhoneOtpScreen(
      {Key? key,
      required this.phoneNumber,
      required this.verificationId,
      required this.token})
      : super(key: key);
  late String verificationId;
  final String phoneNumber;
  final String token;

  @override
  _ChangePhoneOtpScreenState createState() => _ChangePhoneOtpScreenState();
}

class _ChangePhoneOtpScreenState extends State<ChangePhoneOtpScreen> {
  bool isTimeUp = false;
  double time = 60.0;

  @override
  void initState() {
    super.initState();

    _listOPT();
  }

  _listOPT() async {
    // ignore: await_only_futures
    await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(builder: (context, state) {
      return _phoneOtpScaffold;
    }, listener: (context, state) {
      // Verify Profile phone
      if (state is VerifyProfilePhoneLoadSuccess) {
        //Navigator.pushReplacementNamed(context, '/home');
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }

  get _phoneOtpScaffold {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: kPrimaryLightColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        height: 370,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
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
                            onPressed: () {
                              BlocProvider.of<ProfileBloc>(context)
                                ..add(InitialProfileLoginRequested());
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePhoneNumberScreen()),
                              );
                            },
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
                  ChangePhoneOtpForm(
                    routeName: '/home',
                    verificationId: widget.verificationId,
                    phoneNumber: widget.phoneNumber,
                    token: widget.token,
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
            builder: (context) => ChangePhoneOtpScreen(
                phoneNumber: widget.phoneNumber,
                verificationId: verificationId,
                token: widget.token)),
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
    } catch (e) {
      //showToast('Failed to Verify Phone Number: $e');
    }
  }
}

class SampleStrategy extends OTPStrategy {
  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 54321',
    );
  }
}
