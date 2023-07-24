import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/otp/forgot_otp_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/forgot_password/forgot_password_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _verificationId = '';
  String _phone = '';
  String _token = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(),
      child: BlocConsumer<UsersBloc, UsersState>(builder: (context, state) {
        /*
          if (state is UserLoginLoadInProgress) {
            return _loadingSacffold;
          }*/
        if (state is UserForgotPasswordLoadFailure) {
          return _forgotScffold;
        }

        return _forgotScffold;
      }, listener: (context, state) {
        if (state is UserForgotPasswordLoadSuccess) {
          if (state.message != '') {
            _verifyPhoneNumber(state.message);
          }
        }

        if (state is UserForgotPasswordLoadFailure) {
          var data = state.message.toString().replaceAll('Exception: ', '');
          String message = data;
          showToast(message);
        }
      }),
    );
  }

  get _forgotScffold {
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
        height: 330,
        child: ListView(
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
                    LocaleKeys.forgot_password.tr(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              LocaleKeys.please_enter_phone_number.tr(),
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ForgotPasswordForm(
                  token: _token,
                  getPhoneNumber: (value) {
                    setState(() {
                      _phone = value;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String message) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {};

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {};

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      showToast(message);
      _verificationId = verificationId;
      _gotoOTPVerifyPage(_phone, _verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: getPhoneNumberWithCountryCodeFormat(_phone),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {}
  }

  void _gotoOTPVerifyPage(String phoneNumber, String verificationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ForgotOtpScreen(
              phoneNumber: phoneNumber, verificationId: verificationId)),
    );
  }

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      Map<String, dynamic> data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        _token = data['token'];
      });
    }
    super.didChangeDependencies();
  }

  _backPressed() {
    Navigator.pushNamed(context, '/signin');
  }
}
