import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/keyboard_hider.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

// ignore: must_be_immutable
class PersonalProfile extends StatefulWidget {
  final String token;
  String customerName;
  String deliveryLocation;
  int deliAreasId;
  String email;
  String phone;
  String isVerified;
  String? loginType;
  PersonalProfile(
      {Key? key,
      required this.token,
      required this.customerName,
      required this.deliveryLocation,
      required this.deliAreasId,
      required this.email,
      required this.isVerified,
      required this.phone,
      this.loginType})
      : super(key: key);

  @override
  _PersonalProfileState createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile>
    with KeyboardHiderMixin {
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _emailInputController = TextEditingController();
  TextEditingController _phoneInputController = TextEditingController();

  bool editName = false;
  bool editEmail = false;
  bool editPhone = false;
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameInputController = TextEditingController(text: widget.customerName);
    _emailInputController = TextEditingController(text: widget.email);
    _phoneInputController = TextEditingController(
        text: widget.phone.toString() != 'null' ? widget.phone : '');
    isCurrentPasswordVisible = false;
    isNewPasswordVisible = false;
    isConfirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              LocaleKeys.personal_profile.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => _editProfile(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.customerName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ignore: unnecessary_null_comparison
                            widget.email != ''
                                ? Text(
                                    widget.email,
                                  )
                                : SizedBox()
                          ],
                        ),
                        HeroIcon(HeroIcons.pencilAlt)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/change_phone_number',
                          arguments: {
                            'token': widget.token,
                          });
                      /*
                      showDialog(
                        context: context,
                        builder: (context) => _editContactNo(),
                      );*/
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  LocaleKeys.contact_number.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                widget.isVerified.toString() == 'Yes'
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.verified,
                                          size: 18,
                                          color: kPrimaryColor,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.phone.toString() != 'null'
                                      ? widget.phone
                                      : '',
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.phone.toString() != 'null' &&
                                          widget.isVerified.toString() == 'Yes'
                                      ? '(${LocaleKeys.verified.tr()})'
                                      : '(${LocaleKeys.unverified.tr()})',
                                ),
                              ],
                            )
                          ],
                        ),
                        HeroIcon(HeroIcons.pencilAlt)
                      ],
                    ),
                  ),
                  // ignore: unnecessary_null_comparison
                  widget.loginType.toString() == ''
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: BlocConsumer<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                            // Getting Profile page information

                            return InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditPasswordDialog(
                                      token: widget.token, mContext: context),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        LocaleKeys.change_password.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  HeroIcon(HeroIcons.pencilAlt)
                                ],
                              ),
                            );
                          }, listener: (context, state) {
                            if (state is UpdateProfilePasswordLoadSuccess) {
                              //print('from personal profile');
                              BlocProvider.of<ProfileBloc>(context).add(
                                ProfileRequested(
                                    token: widget.token, isFirstTime: false),
                              );
                            }
                          }),
                          /* child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditPasswordDialog(
                                  token: widget.token,
                                  mContext: context
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Change Password',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                HeroIcon(HeroIcons.pencilAlt)
                              ],
                            ),
                          ),
                        */
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateProfile() {
    // Update Profile information
    BlocProvider.of<ProfileBloc>(context).add(ProfileLocationUpdateRequested(
        token: widget.token,
        customerName: widget.customerName,
        deliveryLocation: widget.deliveryLocation,
        deliAreasId: widget.deliAreasId,
        email: widget.email,
        context: context));
  }

  Widget _editProfile() {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Container(
        width: size.width - 40,
        height: 255,
        child: ClipRRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.change_profile.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _editName(),
              SizedBox(height: 20),
              _editEmail(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    child: OutlinedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5),
                      //   side: BorderSide(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        LocaleKeys.cancel.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 45,
                    onPressed: () {
                      var name = _nameInputController.text;
                      var mail = _emailInputController.text;
                      Navigator.of(context).pop();
                      widget.customerName = '$name';
                      widget.email = '$mail';
                      _updateProfile();
                      //setState(() {});
                    },
                    color: kPrimaryColor,
                    child: Text(
                      LocaleKeys.submit.tr(),
                      style: TextStyle(color: kPrimaryLightColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
              BlocConsumer<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                // Getting Profile page information

                return Container();
              }, listener: (context, state) {
                if (state is UpdateProfileInformationLoadSuccess) {
                  if (state.updatedProfile['success']) {
                    // Get Profile information after updating
                    BlocProvider.of<ProfileBloc>(context).add(
                      ProfileRequested(token: widget.token, isFirstTime: true),
                    );
                  }
                }
                if (state is UpdateProfilePasswordLoadSuccess) {
                  //print('from personal profile');
                  BlocProvider.of<ProfileBloc>(context).add(
                    ProfileRequested(token: widget.token, isFirstTime: false),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _editName() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: LocaleKeys.account_name.tr(),
      ),
      controller: _nameInputController,
      onFieldSubmitted: (value) {
        setState(() {
          widget.customerName = value;
          editName = false;
        });
      },
    );
  }

  Widget _editEmail() {
    ///TODO
    return TextFormField(
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: 'Email',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      controller: _emailInputController,
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: (value) {
        setState(() {
          widget.email = value;
          editEmail = false;
        });
      },
    );
  }
  /*
  Widget _editContactNo() {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Container(
        width: size.width - 40,
        height: 200,
        child: ClipRRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Phone Number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _editPhoneNo(),
              //SizedBox(height: 20),
              //_buildVerifyCode(),
              //SizedBox(height: 20),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'This code will expire in ',
                    style: TextStyle(fontSize: 18, color: kBlackColor),
                  ),
                  TweenAnimationBuilder(
                    tween: Tween(begin: 60.0, end: 0.0),
                    duration: Duration(seconds: 60),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toString().split('.')[0]}s',
                        style: TextStyle(fontSize: 16, color: kPrimaryColor),
                      );
                    },
                  ),
                ],
              ),*/
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 45,
                    onPressed: () => _changePhone(),
                    /*
                    onPressed: () {
                      var phone_no = _phoneInputController.text;
                      Navigator.of(context).pop();
                      widget.phone = '$phone_no';
                      _verifyPhone();
                      setState(() {});
                    },*/
                    color: kPrimaryColor,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: kPrimaryLightColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editPhoneNo() {
    return TextFormField(
      controller: _phoneInputController,
      validator: (value) {},
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIcon: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 11.0, left: 10),
            child: Text(
              '+95',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
        /*
        suffixIcon: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          // onPressed: () {},
          onPressed: () {
            _changePhone();
          },
          color: kPrimaryColor,
          textColor: Colors.black,
          child: Text(
            'Apply',
            style: TextStyle(
              color: kPrimaryLightColor,
              fontSize: 16,
            ),
          ),
        ),*/
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

  Widget _buildVerifyCode() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 13),
        hintText: 'Verify OTP Code',
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
  }*/
}

class EditPasswordDialog extends StatefulWidget {
  final String token;
  final BuildContext mContext;
  EditPasswordDialog({required this.token, required this.mContext});
  @override
  _EditPasswordDialogState createState() => new _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  bool _currentPasswordobscureText = true;
  bool _newPasswordobscureText = true;
  bool _confirmPasswordobscureText = true;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPasswordController = TextEditingController(text: '');
    _newPasswordController = TextEditingController(text: '');
    _confirmPasswordController = TextEditingController(text: '');
  }

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
  Widget build(BuildContext context) {
    return _editPassword();
  }

  Widget _editPassword() {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Container(
        width: size.width - 40,
        height: 310,
        child: ClipRRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.change_password.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _currentPasswordField(),
              SizedBox(height: 20),
              _newPasswordField(),
              SizedBox(height: 20),
              _confirmPasswordField(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 45,
                    child: OutlinedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5),
                      //   side: BorderSide(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        LocaleKeys.cancel.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 45,
                    onPressed: () {
                      _changePassword();
                    },
                    color: kPrimaryColor,
                    child: Text(
                      LocaleKeys.submit.tr(),
                      style: TextStyle(color: kPrimaryLightColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentPasswordField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      controller: _currentPasswordController,
      obscureText: _currentPasswordobscureText,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: _toggleCurrentPasswordStatus,
          child: Icon(
              _currentPasswordobscureText
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey),
        ),
        //prefixIcon: HeroIcon(HeroIcons.lockClosed, size: 12.0,),
        hintText: LocaleKeys.password.tr(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onFieldSubmitted: (value) {},
    );
  }

  Widget _newPasswordField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      controller: _newPasswordController,
      obscureText: _newPasswordobscureText,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: _toggleNewPasswordStatus,
          child: Icon(
              _newPasswordobscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
        ),
        hintText: LocaleKeys.new_password.tr(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onFieldSubmitted: (value) {},
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      controller: _confirmPasswordController,
      obscureText: _confirmPasswordobscureText,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: _toggleConfrimPasswordStatus,
          child: Icon(
              _confirmPasswordobscureText
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey),
        ),
        hintText: LocaleKeys.confirm_password.tr(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onFieldSubmitted: (value) {},
    );
  }

  _changePassword() {
    // Update Profile Phone information

    if (_currentPasswordController.text.isEmpty) {
      showToast(
        LocaleKeys.required_current_password_field.tr(),
      );
    } else if (_newPasswordController.text.isEmpty) {
      showToast(
        LocaleKeys.required_password_field.tr(),
      );
    } else if (_confirmPasswordController.text.isEmpty) {
      showToast(
        LocaleKeys.required_confirm_password_field.tr(),
      );
    } else if (_newPasswordController.text.toString() !=
        _confirmPasswordController.text.toString()) {
      showToast(LocaleKeys.not_match_new_password.tr());
    } else {
      BlocProvider.of<ProfileBloc>(context).add(ProfilePasswordUpdateRequested(
          token: widget.token,
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
          context: widget.mContext));
      Navigator.of(context).pop();
      BlocProvider.of<ProfileBloc>(context).add(InitialProfileLoginRequested());
    }
  }
}
