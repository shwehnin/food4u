import 'dart:convert';
import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sign_up/sign_up_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(),
      child: BlocConsumer<UsersBloc, UsersState>(builder: (context, state) {
        return _signUpScffold;
      }, listener: (context, state) {
        if (state is UserCreateAccountLoadSuccess) {
          final User user = User.fromJson(state.userData);
          showToast(
            "Account register successfully.",
          );
          _saveUserInLocal(user);
          _gotoHomeScreen();
        }

        if (state is UserRegisterFacebookLoadSuccess) {
          final User user = User.fromJson(state.userData);
          showToast(
            "Account register successfully.",
          );
          _saveUserInLocal(user);
          _gotoHomeScreen();
        }
        if (state is UserRegisterFacebookLoadFailure) {
          var data = state.message.toString().replaceAll('Exception: ', '');
          String message = data;
          showToast(
            message,
          );
        }

        if (state is UserCreateAccountLoadFailure) {
          var data = state.message.toString().replaceAll('Exception: ', '');
          String message = data;
          showToast(
            message,
          );
        }
      }),
    );
  }

  get _signUpScffold {
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
        height: 660,
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
                      onPressed: () => Navigator.pop(context),
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
                    LocaleKeys.sign_up.tr(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      color: kPrimaryColor,
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      child: HeroIcon(
                        HeroIcons.home,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SignUpForm(),
          ],
        ),
      ),
    );
  }

  _saveUserInLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userString = json.encode(user);
    prefs.setString('user', userString);
  }

  _gotoHomeScreen() async {
    Navigator.pushReplacementNamed(context, '/home');
  }

  _backPressed() {
    Navigator.pop(context);
  }
}
