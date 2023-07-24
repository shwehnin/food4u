import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/change_password/forgot_change_password.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class OtpForm extends StatefulWidget {
  const OtpForm(
      {Key? key,
      required this.routeName,
      this.phoneNumber,
      this.verificationId})
      : super(key: key);
  final String routeName;
  final String? verificationId;
  final String? phoneNumber;

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  late FocusNode pin5FocusNode;
  late FocusNode pin6FocusNode;

  TextEditingController _pin1Controller = new TextEditingController();
  TextEditingController _pin2Controller = new TextEditingController();
  TextEditingController _pin3Controller = new TextEditingController();
  TextEditingController _pin4Controller = new TextEditingController();
  TextEditingController _pin5Controller = new TextEditingController();
  TextEditingController _pin6Controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    super.dispose();
  }

  void nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: TextFormField(
                  controller: _pin1Controller,
                  textAlignVertical: TextAlignVertical.top,
                  autofocus: false,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: TextFormField(
                  controller: _pin2Controller,
                  focusNode: pin2FocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: TextFormField(
                  controller: _pin3Controller,
                  focusNode: pin3FocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: TextFormField(
                  controller: _pin4Controller,
                  focusNode: pin4FocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin5FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: TextFormField(
                  controller: _pin5Controller,
                  focusNode: pin5FocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin6FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: TextFormField(
                  controller: _pin6Controller,
                  focusNode: pin6FocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FocusNode.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width - 20,
                height: 45,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onPressed: () => _checkOtpString(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(
                        Icons.verified,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        LocaleKeys.verify.tr(),
                        // ignore: unnecessary_const
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _signInWithPhoneNumber(String otpString) async {
    User user;
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId!, smsCode: otpString);
      user = (await _auth.signInWithCredential(credential)).user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        _gotoResetPasswordPage();
      }
    } catch (e) {
      String message = e.toString().split(']')[1];
      if (!message.contains('The sms code has expired')) showToast(message);
    }
  }

  void _gotoResetPasswordPage() {
    // ForgotChangePasswordScreen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotChangePasswordScreen(
            phoneNumber: widget.phoneNumber!,
          ),
        ));
  }

  _checkOtpString() {
    if (_pin1Controller.text.isEmpty ||
        _pin2Controller.text.isEmpty ||
        _pin3Controller.text.isEmpty ||
        _pin4Controller.text.isEmpty ||
        _pin5Controller.text.isEmpty ||
        _pin6Controller.text.isEmpty) {
      showToast(LocaleKeys.requiredverify_code_field.tr());
    } else {
      String _otpString = _pin1Controller.text.toString() +
          _pin2Controller.text.toString() +
          _pin3Controller.text.toString() +
          _pin4Controller.text.toString() +
          _pin5Controller.text.toString() +
          _pin6Controller.text.toString();
      _signInWithPhoneNumber(_otpString);
    }
  }
}
