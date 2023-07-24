import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ForgotPasswordForm extends StatefulWidget {
  Function(String) getPhoneNumber;
  final String token;

  ForgotPasswordForm(
      {Key? key, required this.getPhoneNumber, required this.token})
      : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  late String email;
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
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
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
              hintText: LocaleKeys.phone_number.tr(),
              hintStyle: TextStyle(fontSize: 14),
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

          /// TODO
          SizedBox(
            width: size.width,
            height: 45,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: kPrimaryColor,
              onPressed: () => _forgotPassword(),
              child: Text(
                LocaleKeys.forgot_password.tr(),
                style: TextStyle(fontSize: 16, color: kPrimaryLightColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  _forgotPassword() {
    if (_phoneController.text.isEmpty) {
      showToast(LocaleKeys.required_phone_field.tr());
    } else {
      BlocProvider.of<UsersBloc>(context)
        ..add(UserForgotPasswordRequested(phone: _phoneController.text));
      widget.getPhoneNumber(_phoneController.text);
    }
  }
}
