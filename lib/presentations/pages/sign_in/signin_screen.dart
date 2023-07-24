import 'dart:convert';
import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sign_in/sign_in_form.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/splash/background_image.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _isFacebookLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _gotoHomeScreen(),
      child: BlocConsumer<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UserLoginLoadFailure) {
            return _signInScaffold;
          }

          return _signInScaffold;
        },
        listener: (context, state) {
          if (state is UserLoginLoadInProgress ||
              state is UserLoginFacebookLoadInProgress) {
            EasyLoading.show(status: LocaleKeys.loading.tr());
          }
          if (state is UserLoginLoadSuccess) {
            final User user = User.fromJson(state.userData);

            showSuccessMessage('Welcome back!');
            _saveUserInLocal(user);
            _gotoHomeScreen();
            EasyLoading.dismiss();
          }

          if (state is UserRegisterFacebookLoadSuccess) {
            final User user = User.fromJson(state.userData);

            String message = "Welcome back!";
            showSuccessMessage(
              message,
            );
            _saveUserInLocal(user);
            _saveLoginType('facebook');
            _gotoHomeScreen();
          }
          if (state is UserRegisterFacebookLoadFailure) {
            var data = state.message.toString().replaceAll('Exception: ', '');
            String message = data;
            showToast(
              message,
            );
          }

          if (state is UserLoginLoadFailure) {
            var data = state.message.toString().replaceAll('Exception: ', '');
            String message = data;
            EasyLoading.showError(message,
                duration: Duration(milliseconds: 1000));
          }
        },
      ),
    );
  }

  get _signInScaffold {
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
        height: 520,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    LocaleKeys.sign_in.tr(),
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
            SigninForm(
              onSelectedType: (String param) {
                setState(() {
                  _isFacebookLogin = param == 'true' ? true : false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _saveUserInLocal(User user) async {
    final prefs = await SharedPreferences.getInstance();
    //print('user $user');
    String userString = json.encode(user);
    prefs.setString('user', userString);
  }

  _saveLoginType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loginType', type);
  }

  _gotoHomeScreen() async {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
