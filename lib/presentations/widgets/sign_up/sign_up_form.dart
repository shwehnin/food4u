import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sign_up/region.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  var _phone;
  late String password;
  late String conform_password;
  bool remember = false;

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  bool _myBool = false;

  int? _deliveryAreaID;
  late UsersBloc _usersBloc;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  TextEditingController _deliveryLocationController =
      new TextEditingController();

  Company? _company;
  String _fcmToken = '';

  @override
  void initState() {
    super.initState();
    _usersBloc = BlocProvider.of<UsersBloc>(context);
    _getCompanyValues();
    _firebaseCloudMessaging_Listeners();
  }

  void _togglePasswordStatus() {
    setState(() {
      _passwordObscureText = !_passwordObscureText;
    });
  }

  void _toggleConfirmPasswordStatus() {
    setState(() {
      _confirmPasswordObscureText = !_confirmPasswordObscureText;
    });
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                  _buildNameFormField(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildPasswordFormField(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildConfirmPasswordField(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildDeliveryLocationFormField(),
                  SizedBox(
                    height: 20,
                  ),
                  Region(
                    onSelectArea: (String param) {
                      setState(() {
                        _deliveryAreaID = int.parse(param);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () => setState(() => _myBool = !_myBool),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Checkbox(
                          value: _myBool,
                          onChanged: (value) {
                            setState(() => _myBool = value!);
                          },
                          activeColor: kPrimaryColor,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: size.width - 80,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      'I agree to ${_company != null ? _company!.companyName!.toString() : kMaterialAppTitle}\'s '),
                              TextSpan(
                                text: LocaleKeys.terms_and_conditions.tr(),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => launchURL(termUrl),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
                onPressed: () => _signUpAccount(),
                child: Text(
                  LocaleKeys.sign_up.tr(),
                  style: TextStyle(color: kPrimaryLightColor, fontSize: 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneFormField() {
    return TextFormField(
      controller: _phoneController,
      validator: (value) {},
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
    );
  }

  Widget _buildNameFormField() {
    ///TODO
    return TextFormField(
      controller: _nameController,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 13),
        hintText: LocaleKeys.account_name.tr(),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildDeliveryLocationFormField() {
    return TextFormField(
      controller: _deliveryLocationController,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 13),
        hintText: LocaleKeys.delivery_location.tr(),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildPasswordFormField() {
    return Container(
      height: 50,
      child: TextFormField(
        controller: _passwordController,
        obscureText: _passwordObscureText,
        cursorColor: kPrimaryColor,
        onChanged: (value) {},
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          hintText: LocaleKeys.password.tr(),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: InkWell(
            onTap: _togglePasswordStatus,
            child: Icon(
                _passwordObscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey),
          ),
        ),
      ),
    );
  }

  TextFormField _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _confirmPasswordObscureText,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 13),
        hintText: LocaleKeys.confirm_password.tr(),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        fillColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: InkWell(
          onTap: _toggleConfirmPasswordStatus,
          child: Icon(
              _confirmPasswordObscureText
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey),
        ),
      ),
    );
  }

  _signUpAccount() {
    if (_phoneController.text.isEmpty) {
      showToast(LocaleKeys.required_phone_field.tr());
    } else if (_nameController.text.isEmpty) {
      showToast(LocaleKeys.required_customer_name.tr());
    } else if (_deliveryLocationController.text.isEmpty) {
      showToast(LocaleKeys.required_delivery_address.tr());
    } else if (_deliveryAreaID == null || _deliveryAreaID == 0) {
      showToast(LocaleKeys.required_deli_areas_id.tr());
    } else if (_passwordController.text.isEmpty) {
      showToast(LocaleKeys.required_password_field.tr());
    } else if (_confirmPasswordController.text.isEmpty) {
      showToast(
        LocaleKeys.required_confirm_password_field.tr(),
      );
    } else if (_passwordController.text.toString() !=
        _confirmPasswordController.text.toString()) {
      showToast(LocaleKeys.not_match_new_password.tr());
    } else if (!_myBool) {
      showToast(
          'Please agree ${LocaleKeys.terms_of_service.tr()}, ${LocaleKeys.privacy_policy.tr()} ${LocaleKeys.and.tr()} ${LocaleKeys.content_policies.tr()}');
    } else {
      _usersBloc
        ..add(UserCreateAccountRequested(
            name: _nameController.text,
            phone: getPhoneNumberFormat(_phoneController.text),
            deliveryLocation: _deliveryLocationController.text,
            password: _passwordController.text,
            deliveryAreaId: _deliveryAreaID!,
            fcmToken: _fcmToken));
    }
  }

  _getCompanyValues() async {
    Company? value = await _readCompanyValue();
    if (value != null) {
      setState(() {
        _company = value;
      });
    }
  }

  Future<Company?> _readCompanyValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('company') != null) {
      var _company =
          Company.fromCompanyList(json.decode(prefs.getString('company')!));
      return _company;
    } else {
      return null;
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
