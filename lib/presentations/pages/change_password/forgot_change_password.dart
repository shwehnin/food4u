import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/change_password/change_password_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotChangePasswordScreen extends StatefulWidget {
  const ForgotChangePasswordScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  _ForgotChangePasswordScreenState createState() =>
      _ForgotChangePasswordScreenState();
}

class _ForgotChangePasswordScreenState
    extends State<ForgotChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(builder: (context, state) {
      /*
        if (state is UserLoginLoadInProgress) {
          return ;
        }*/
      if (state is UserResetPasswordLoadFailure) {
        return _forgotChangeScaffold;
      }

      return _forgotChangeScaffold;
    }, listener: (context, state) {
      if (state is UserResetPasswordLoadSuccess) {
        final User user = User.fromJson(state.userData);
        showSuccessMessage("Reset password successfully.");
        _saveUserInLocal(user);
        _gotoHomeScreen();
      }

      if (state is UserResetPasswordLoadFailure) {
        var data = state.message.toString().replaceAll('Exception: ', '');

        String message = data;
        showErrorMessage(message);
      }
    });
  }

  get _forgotChangeScaffold {
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
        height: 280,
        child: ListView(
          children: [
            SizedBox(
              height: 10,
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
                      child: SvgPicture.asset(
                        "assets/icons/Back ICon.svg",
                        height: 15,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    LocaleKeys.change_password.tr(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            ChangePasswordForm(
              type: 'forgot',
              phoneNumber: widget.phoneNumber,
            ),
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
}
