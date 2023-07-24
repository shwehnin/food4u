import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:bestcannedfood_ecommerce/blocs/notifications/notifications_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/model/notification.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/notification_list_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationsBloc _notificationsBloc;
  List<Notifications> notifications = [];

  bool isRead = false;
  String _token = '';

  void notiUnread(String unread) {
    notifications.removeWhere((unr) => unr.id == (unread).toString());
  }

  @override
  void initState() {
    super.initState();
    _notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
    _getUserValues();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoadSuccess) {
          notifications = List<Notifications>.from(
            state.notifications['data'].map(
              (i) => Notifications.fromNotificationsList(i),
            ),
          ).toList();

          return Scaffold(
            backgroundColor: kPrimaryLightColor,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [_getNotificationsList()],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is NotificationsLoadFailure && _token == '') {
          return Scaffold(
            backgroundColor: kPrimaryLightColor,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _appBarSection,
                            SizedBox(
                              height: 100,
                            ),
                            Lottie.asset(
                              'assets/icons/nonotification.json',
                              height: 200,
                            ),
                            Text(
                              LocaleKeys.no_notification_yet.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return NotificationListLoading();
      },
      listener: (context, state) {},
    );
  }

  Widget _getNotificationsList() {
    return notifications.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notifications.length + 1,
            itemBuilder: (BuildContext context, index) {
              if (index == 0) {
                return _appBarSection;
              } else {
                return GestureDetector(
                  onTap: () => _notificationReaded(notifications[index - 1]),
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: HeroIcon(
                                      HeroIcons.shoppingBag,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      '${(notifications[index - 1].notification!.title).toString()}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),

                              // !isRead
                              // ignore: unnecessary_null_comparison
                              // notifications[index - 1].readAt.toString() != null
                              //     ? Badge(
                              //         position: BadgePosition.topEnd(
                              //             top: -3, end: -6),
                              //         badgeColor: kPrimaryColor,
                              //       )
                              //     : Container()
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${(notifications[index - 1].notification!.subtitle).toString()}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${(notifications[index - 1].notification!.time).toString()}',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _appBarSection,
                SizedBox(
                  height: 100,
                ),
                Lottie.asset(
                  'assets/icons/nonotification.json',
                  height: 200,
                ),
                Text(
                  LocaleKeys.no_notification_yet.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }

  _getUserValues() async {
    User? userValue = await _readUserValue();
    if (userValue != null) {
      setState(() {
        _token = userValue.token!;
      });
    }
    _initializeBlocs();
  }

  Future<User?> _readUserValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      var user = User.fromSharePreJson(json.decode(prefs.getString('user')!));
      return user;
    } else {
      return null;
    }
  }

  void _initializeBlocs() {
    _notificationsBloc
      ..add(
        NotificationsListRequested(token: _token),
      );
  }

  _notificationReaded(Notifications notification) {
    _notificationsBloc
      ..add(NotificationsListDeleteRequested(
          token: _token, id: notification.id!));

    List<String> arg = [
      notification.orderId.toString(),
      '1',
      _token,
      'notification'
    ];
    Navigator.pushNamed(context, '/order_detail', arguments: arg);
  }

  get _appBarSection {
    return CustomAppBar(
      leading: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        color: kButtonBackgroundColor.withOpacity(0.1),
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        child: SvgPicture.asset(
          "assets/icons/Back ICon.svg",
          height: 15,
        ),
      ),
      title: '${LocaleKeys.notifications.tr()}(${notifications.length} unread)',
      action: [],
    );
  }
}
