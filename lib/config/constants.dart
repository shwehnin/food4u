import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/carts/carts_bloc.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/favorite/favorite_screen.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

/// Change_ECOMMERCE
const kMaterialAppTitle = 'Best Canned Food Delivery Service';
const baseUrl = 'https://bestcannedfood.com/creator/api/v1/bs_shop/';
const termUrl = 'https://bestcannedfood.com/terms-of-service';
const forgotToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiaXp6c3luYy1lY29tbWVyY2UifQ.a_kAArhJ9W3HCHH8pKdiU8ZWAImp7GDC4pJCxTL4XJw';

const kLogoImageUrl =
    'https://bestcannedfood.com/creator/uploads/SF_Logo-removebg-607b4db4-1d1c-43b8-9336-34014423e219.png';
const popularFoodsLimit = 10;
const latestFoodsLimit = 12;
const deliveryTimeText = 'hrs';
const deliveryDayText = 'days';
const deliveryYearText = 'years';

const kGoldColor = Color(0xFFFFD700);
const kPrimaryColor = Color(0xFFE73324);
const kHeadingColor = Color(0xFFF58B14);
const kHeartColor = Colors.red;
const kPrimaryLightColor = Color(0xFFFFFFFF);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xff212121);
const kWhiteColor = Color(0xFFe5e5e5);
const kButtonBackgroundColor = Color(0xFF979797);
Color kScaffoldBackgroundColor = Colors.grey.shade100;
const kBlackColor = Colors.black;
final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: kPrimaryColor, width: 2),
  );
}

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

getErrorText(var responseJson) {
  if (responseJson['message'] != null) {
    return responseJson['message'];
  } else if (responseJson['errors'] != null) {
    String message = responseJson['errors']
        .values
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    return message;
  } else {
    String message = responseJson['error']
        .values
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    return message;
  }
}

final currencyFormat = new NumberFormat("#,##0.00", "en_US");

getCurrencyDoubleFormat(String format, double price) {
  return '$format ${currencyFormat.format(price)}';
}

getCurrencyFormat(String format, int price) {
  return '$format ${currencyFormat.format(price)}';
}

showToast(String message) {
  EasyLoading.showToast(
    message,
    toastPosition: EasyLoadingToastPosition.bottom,
  );
}

showSuccessMessage(String message) {
  EasyLoading.showSuccess(message, duration: Duration(seconds: 5));
}

showInfoMessage(String message) {
  EasyLoading.showInfo(message, duration: Duration(seconds: 5));
}

showErrorMessage(String message) {
  EasyLoading.showError(message, duration: Duration(milliseconds: 5000));
}

showSnacknar(String message, BuildContext context, String token) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'View Cart',
        textColor: kPrimaryLightColor,
        onPressed: () {
          //FoodsBloc _foodsBloc = BlocProvider.of<FoodsBloc>(context);
          //_foodsBloc..add(InitialFoodsRequested());

          CartsBloc _cartsBloc = BlocProvider.of<CartsBloc>(context);
          _cartsBloc.add(InitialCartRequested());
          Navigator.pushNamed(context, '/cart');
        },
      )));
}

showFavouriteSnackbar(String message, BuildContext context, String token) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.contains('Removed')
          ? LocaleKeys.removed_from_favourites.tr()
          : LocaleKeys.added_to_favourites.tr()),
      action: SnackBarAction(
        label: message.contains('Removed') ? '' : 'View Favourite',
        textColor: kPrimaryLightColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoriteScreen(
                token: token,
                isShowAppbar: true,
              ),
            ),
          );
        },
      )));
}

launchSocial(String url, String fallbackUrl) async {
  // Don't use canLaunch because of fbProtocolUrl (fb://)
  try {
    bool launched =
        await launch(url, forceSafariVC: false, forceWebView: false);
    if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  } catch (e) {
    await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  }
}

List<String> timeNameList = [
  'Morning (9:00 AM - 1:00 PM)',
  'Evening (2:00 PM - 5:00 PM)'
];
List<String> timeDataList = ['09:00:00', '14:00:00'];

Future<void> iosPermission() async {
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //print('User granted provisional permission');
  } else {
    //print('User declined or has not accepted permission');
  }
}
