import 'dart:io';

import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sign_in/already_have_an_account.dart';
import 'package:bestcannedfood_ecommerce/services/facebook_login.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninForm extends StatefulWidget {
  SigninForm({
    Key? key,
    required this.onSelectedType,
  }) : super(key: key);
  Function(String) onSelectedType;

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  late UsersBloc _usersBloc;
  late String phone;
  late String password;
  bool _obscureText = true;
  late bool remember = false;
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _fcmToken = '';

  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _usersBloc = BlocProvider.of<UsersBloc>(context);
    _firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildPhoneFormField(),
                SizedBox(
                  height: 20,
                ),
                _buildPasswordFormField(),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/forgot_password',
                      arguments: {'token': forgotToken, 'type': 'forgot'});
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.forgot_your_password.tr(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              minWidth: size.width,
              height: 45,
              color: kPrimaryColor,
              onPressed: () => _callLoginRequested(),
              child: Text(
                LocaleKeys.sign_in.tr(),
                style: TextStyle(color: kPrimaryLightColor, fontSize: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          AlreadyHaveAnAccount(
            press: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                LocaleKeys.or.tr(),
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
              minWidth: size.width,
              height: 45,
              onPressed: () => signWithFacebook().then((value) {
                if (value.length != 0) _checkFacebookLogin(value);
              }),
              color: Color(0xff3b5998),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook, color: kPrimaryLightColor),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    LocaleKeys.sign_in_with_facebook.tr(),
                    style: TextStyle(fontSize: 16, color: kPrimaryLightColor),
                  ),
                ],
              ),
            ),
          ),
          Platform.isIOS
              ? Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SignInWithAppleButton(
                    style: SignInWithAppleButtonStyle.black,
                    text: LocaleKeys.sign_in_with_apple.tr(),
                    onPressed: () async {
                      try {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );

                        if (credential.userIdentifier != null) {
                          widget.onSelectedType('false');
                          _usersBloc
                            ..add(UserRegisterFacebookRequested(
                                facebookId:
                                    credential.userIdentifier.toString(),
                                name:
                                    credential.givenName.toString() != 'null' &&
                                            credential.familyName.toString() !=
                                                'null'
                                        ? credential.givenName.toString() +
                                            ' ' +
                                            credential.familyName.toString()
                                        : '',
                                email: credential.email.toString() != 'null'
                                    ? credential.email.toString()
                                    : '',
                                fcmToken: _fcmToken));
                        }
                      } catch (error) {}
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildPhoneFormField() {
    return TextFormField(
      // controller: TextEditingController(),
      validator: (value) {},
      controller: _phoneNumberController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: LocaleKeys.phone_number.tr(),
        prefixIcon: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 10),
            child: Text(
              '+95',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade300),
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
    );
  }

  TextFormField _buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        hintText: LocaleKeys.password.tr(),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        fillColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: InkWell(
          onTap: _togglePasswordStatus,
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
        ),
      ),
    );
  }

  _callLoginRequested() {
    String phoneNumber = _phoneNumberController.text.toString();
    //print('phone ${getPhoneNumberFormat(phoneNumber)}');
    String password = _passwordController.text.toString();

    if (_phoneNumberController.text.isEmpty) {
      showToast(LocaleKeys.required_phone_field.tr());
    } else if (_passwordController.text.isEmpty) {
      showToast(LocaleKeys.required_customer_name.tr());
    } else {
      _usersBloc
        ..add(UserLoginRequested(
            phone: getPhoneNumberFormat(phoneNumber),
            password: password,
            fcmToken: _fcmToken));
    }
  }

  void _checkFacebookLogin(Map<String, dynamic> value) {
    widget.onSelectedType('true');
    _usersBloc
      ..add(UserRegisterFacebookRequested(
          facebookId: value['id'],
          name: value['name'],
          email: value['email'],
          fcmToken: _fcmToken));
  }

  // ignore: non_constant_identifier_names
  _firebaseCloudMessaging_Listeners() {
    try {
      iosPermission();

      _firebaseMessaging.getToken().then((token) {
        if (token != null) {
          setState(() {
            _fcmToken = token;
          });
        }
      });
    } catch (e) {}
  }
}
