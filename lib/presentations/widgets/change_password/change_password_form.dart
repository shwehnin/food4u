import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm(
      {Key? key, required this.type, required this.phoneNumber})
      : super(key: key);

  final String type;
  final String phoneNumber;
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  late String password;
  bool _currentPasswordobscureText = true;
  bool _newPasswordobscureText = true;
  bool _confirmPasswordobscureText = true;
  String _fcmToken = '';

  late bool remember = false;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

  void _toggleCurrentPasswordStatus() {
    setState(() {
      _currentPasswordobscureText = !_currentPasswordobscureText;
    });
  }

  void _toggleNewPasswordStatus() {
    setState(() {
      _newPasswordobscureText = !_newPasswordobscureText;
    });
  }

  void _toggleConfrimPasswordStatus() {
    setState(() {
      _confirmPasswordobscureText = !_confirmPasswordobscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            widget.type.toString() == 'change'
                ? _buildCurrentPasswordFormField()
                : Container(),
            widget.type.toString() == 'change'
                ? SizedBox(
                    height: 10,
                  )
                : Container(),
            _buildPasswordFormField(),
            SizedBox(
              height: 10,
            ),
            _buildConfirmPasswordFormField(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: kPrimaryColor,
                onPressed: () {
                  if (widget.type != 'change') {
                    _resetPassword();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  LocaleKeys.submit.tr(),
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFormField _buildCurrentPasswordFormField() {
    return TextFormField(
      obscureText: _currentPasswordobscureText,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: 'Current Password',
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: InkWell(
          onTap: _toggleCurrentPasswordStatus,
          child: Icon(
              _currentPasswordobscureText
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey),
        ),
      ),
    );
  }

  TextFormField _buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _newPasswordobscureText,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
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
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: InkWell(
          onTap: _toggleNewPasswordStatus,
          child: Icon(
              _newPasswordobscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
        ),
      ),
    );
  }

  TextFormField _buildConfirmPasswordFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _confirmPasswordobscureText,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        hintText: LocaleKeys.confirm_password.tr(),
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
          onTap: _toggleConfrimPasswordStatus,
          child: Icon(
              _confirmPasswordobscureText
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey),
        ),
      ),
    );
  }

  void _resetPassword() {
    if (_passwordController.text.isEmpty) {
      showToast(LocaleKeys.required_password_field.tr());
    } else if (_confirmPasswordController.text.isEmpty) {
      showToast(LocaleKeys.required_password_field.tr());
    } else {
      BlocProvider.of<UsersBloc>(context)
        ..add(UserResetPasswordRequested(
            phone: widget.phoneNumber,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            fcmToken: _fcmToken));
    }
  }

  // ignore: non_constant_identifier_names
  _firebaseCloudMessaging_Listeners() {
    try {
      iosPermission();

      firebaseMessaging.getToken().then((token) {
        if (token != null) {
          setState(() {
            _fcmToken = token;
          });
        }
      });
    } catch (e) {}
  }
}
