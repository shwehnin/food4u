import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNoti = false;
  bool _isLanguageEnglish = true;

  var textHolder = 'Notification OFF';
  late Future<void> _launched;
  String _launchUrl = 'https://teclink.kaungmyan.app/';

  @override
  void initState() {
    super.initState();
  }

  void pushNoti(bool value) {
    if (_pushNoti == false) {
      setState(() {
        _pushNoti = true;
      });
    } else {
      setState(() {
        _pushNoti = false;
      });
    }
  }

  Future<void> changeLanguage(bool value) async {
    if (_isLanguageEnglish == false) {
      setState(() {
        _isLanguageEnglish = true;
      });
      await context.setLocale(const Locale('en'));
    } else {
      setState(() {
        _isLanguageEnglish = false;
      });
      await context.setLocale(const Locale('my'));
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  websiteUrl() async {
    const url = 'http://teclinkmyanmar.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  appUrl() async {
    const url = 'https://teclink.kaungmyan.app/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: CustomAppBar(
                  leading: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    color: kButtonBackgroundColor.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/Back ICon.svg",
                      height: 15,
                    ),
                  ),
                  title: '',
                  action: [],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _getList()),
              // NotiSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.language.tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/images/english.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      LocaleKeys.language_en.tr(),
                    )
                  ],
                ),
              ),
              Switch(
                onChanged: changeLanguage,
                value: context.locale.toString() == 'en' ? true : false,
                activeColor: kPrimaryLightColor,
                activeTrackColor: kPrimaryColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ],
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/images/mm.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      LocaleKeys.language_mm.tr(),
                    )
                  ],
                ),
              ),
              Switch(
                onChanged: changeLanguage,
                value: context.locale.toString() == 'my' ? true : false,
                activeColor: kPrimaryLightColor,
                activeTrackColor: kPrimaryColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
