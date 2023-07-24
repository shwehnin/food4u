import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/otp/change_phone_otp_screen.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart' as mUser;
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ChangePhoneNumberScreen extends StatefulWidget {
  const ChangePhoneNumberScreen({Key? key}) : super(key: key);

  @override
  _ChangePhoneNumberScreenState createState() =>
      _ChangePhoneNumberScreenState();
}

class _ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  String _verificationId = '';
  String _token = '';
  String _type = '';
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  late String email;
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(builder: (context, state) {
      return _forgotScffold;
    }, listener: (context, state) {
      if (state is UpdateProfilePhoneLoadSuccess) {
        mUser.User _user = mUser.User.fromJson(state.updatedProfile);
        final mUser.User user = mUser.User(
            customerName: _user.customerName,
            email: _user.email,
            deliveryLocation: _user.deliveryLocation,
            phoneVerified: _user.phoneVerified,
            fcmToken: _user.fcmToken,
            deliAreasId: _user.deliAreasId,
            phone: _user.phone,
            token: _token);

        _saveUserInLocal(user);
        _verifyPhoneNumber();
      }
    });
  }

  get _forgotScffold {
    Size size = MediaQuery.of(context).size;

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
                    // ignore: deprecated_member_use
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      color: kPrimaryColor,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);

                        BlocProvider.of<ProfileBloc>(context)
                          ..add(ProfileRequested(
                              token: _token, isFirstTime: false));
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
                  child: Container(
                    width: MediaQuery.of(context).size.width - 140,
                    child: Text(
                      LocaleKeys.change_verify_phone.tr(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      validator: (value) {},
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      cursorColor: kPrimaryColor,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                        prefixIcon: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14.0, left: 10),
                            child: Text(
                              '+95',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // fillColor: kPrimaryColor,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: size.width,
                      height: 45,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: kPrimaryColor,
                        onPressed: () => _changePhoneNumber(),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 16, color: kPrimaryLightColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      //await _auth.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showToast(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;

      _gotoOTPVerifyPage(_phoneController.text, _verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber:
              getPhoneNumberWithCountryCodeFormat(_phoneController.text),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      //showToast('Failed to Verify Phone Number: $e');
    }
  }

  _gotoOTPVerifyPage(String phoneNumber, String verificationId) async {
    final signature = await SmsAutoFill().getAppSignature;
    print(signature);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChangePhoneOtpScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
              token: _token)),
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
        _type = data['type'];
      });
    }
    super.didChangeDependencies();
  }

  _saveUserInLocal(mUser.User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    String userString = json.encode(user);
    prefs.setString('user', userString);
  }

  _changePhoneNumber() {
    if (_phoneController.text.isEmpty) {
      showToast(LocaleKeys.required_phone_field.tr());
    } else {
      FocusScope.of(context).unfocus();
      if (_type != 'verify') {
        BlocProvider.of<ProfileBloc>(context)
          ..add(ProfilePhoneUpdateRequested(
              token: _token, phone: _phoneController.text));
      } else {
        _verifyPhoneNumber();
      }
    }
  }
}
