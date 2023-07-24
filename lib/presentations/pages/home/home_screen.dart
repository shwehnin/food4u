import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/categories/categories_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/companies/companies_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_event.dart';
import 'package:bestcannedfood_ecommerce/blocs/foods/foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/news/news_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/notifications/notifications_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/popular_foods/popular_foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/voucher/voucher_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/model/news.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/icon_btn_with_counter.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/image_slider.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/category_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/news_item_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/show_all_button.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/cart/cart_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/favorite/favorite_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/notification/notification_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/profile_screen/profile_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/shop/shop_detail_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sidebar/sidebar_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/category.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/latest_food.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/popular_food.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/search_filter.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/home/title_span.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart'
    as kPriority;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  String _token = '';
  String _type = '';

  int pageIndex = 0;
  String _pageName = 'home';
  Widget _page = HomeScreen();

  late NewsBloc _newsBloc;
  late CategoriesBloc _categoriesBloc;
  late PopularFoodsBloc _foodsBloc;
  late FoodsBloc _latestFoodsBloc;
  late NotificationsBloc _notificationBloc;
  late VoucherBloc _voucherBloc;
  late CompaniesBloc _companiesBloc;

  List<News> priorityList = [];
  List<String> titleList = [];
  List<String> imgList = [];
  List<String> idList = [];
  List<Company> companies = [];
  User? _user;
  int _newsTotal = 0;

  void onTappedBar(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  List<FoodMaster> _foodsList = [];
  int _notiCount = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher_foreground');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);

    _getUserValues();
    iosPermission();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return WillPopScope(
      onWillPop: () async => false,
      child: ConnectivityBuilder(
        builder: (context, isConnected, status) {
          if (isConnected.toString() != 'false') {
            return _homeSafeAreaSection;
          } else {
            return NoInternetWidget();
          }
        },
      ),
    );
  }

  get _homeSafeAreaSection {
    return SafeArea(
      top: false,
      bottom: false,
      child: AdvancedDrawer(
          backdropColor: kPrimaryColor,
          controller: _advancedDrawerController,
          animationCurve: Curves.easeOutCirc,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: pageIndex != 0 ? true : false,
          childDecoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          drawer: BlocConsumer<VoucherBloc, VoucherState>(
              builder: (context, state) {
                if (state is VoucherListLoadSuccess) {
                  return Container(
                    child: SidebarScreen(
                      user: _user,
                      voucherCount: state.voucherList['data'].length,
                      newsCount: _newsTotal,
                    ),
                  );
                }
                return Container(
                  child: SidebarScreen(
                    user: _user,
                    voucherCount: null,
                    newsCount: _newsTotal,
                  ),
                );
              },
              listener: (context, state) {}),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                toolbarHeight: 0.0, // status bar color
                brightness: Brightness.light, // status bar brightness
              ),
              resizeToAvoidBottomInset: true,
              backgroundColor: kPrimaryLightColor,
              bottomNavigationBar: _getHomeButtonNavigationBar,
              body: pageIndex == 0 ? _getHomeScaffold : _page,
            ),
          )),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  get _getAppbarSection {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: IconBtnWithCounter(
                      svgSrc: HeroIcon(
                        value.visible ? HeroIcons.x : HeroIcons.menuAlt2,
                        size: 17,
                      ),
                      press: _handleMenuButtonPressed,
                    ));
              },
            ),
            SizedBox(
              width: 10,
            ),
            SearchFilter(
              token: _token,
            ),
          ],
        ),
        BlocConsumer<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoadSuccess) {
              _notiCount = state.notifications['data'].length;
            }

            return Builder(builder: (context) {
              return IconBtnWithCounter(
                svgSrc: HeroIcon(
                  HeroIcons.bell,
                  size: 17,
                ),
                numOfitem: _notiCount,
                press: () {
                  Navigator.pushReplacementNamed(context, '/notification');
                },
              );
            });
          },
          listener: (context, state) {},
        )
      ],
    );
  }

  get _getHomeButtonNavigationBar {
    return Container(
      child: CurvedNavigationBar(
        index: pageIndex,
        color: kPrimaryColor,
        buttonBackgroundColor: kPrimaryColor,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        height: 50,
        items: <Widget>[
          HeroIcon(
            HeroIcons.home,
            size: 25,
            color: Colors.white,
            solid: _getSolidIconState('home'),
          ),
          HeroIcon(
            HeroIcons.map,
            size: 25,
            color: Colors.white,
            solid: _getSolidIconState('map'),
          ),
          HeroIcon(
            HeroIcons.shoppingCart,
            size: 25,
            color: Colors.white,
            solid: _getSolidIconState('cart'),
          ),
          HeroIcon(
            HeroIcons.heart,
            size: 25,
            color: Colors.white,
            solid: _getSolidIconState('favourite'),
          ),
          HeroIcon(
            HeroIcons.user,
            size: 25,
            color: Colors.white,
            solid: _getSolidIconState('account'),
          ),
        ],
        onTap: (index) {
          onTappedBar(index);
          setState(() {
            switch (index) {
              case 0:
                _page = HomeScreen();
                _pageName = 'home';

                break;
              case 1:
                _page = ShopDetailScreen();
                _pageName = 'map';
                break;
              case 2:
                if (_token == '') {
                  Navigator.pushReplacementNamed(context, "/signin");
                } else {
                  _page = CartScreen(
                    isShowbackButton: false,
                  );
                  _pageName = 'cart';
                }
                break;
              case 3:
                if (_token == '') {
                  Navigator.pushReplacementNamed(context, "/signin");
                } else {
                  FavouritesBloc favouritesBloc =
                      BlocProvider.of<FavouritesBloc>(context);
                  favouritesBloc..add(InitialFavouriteRequested());

                  _page = FavoriteScreen(
                    token: _token,
                    isShowAppbar: false,
                  );
                  _pageName = 'favourite';
                }
                break;

              case 4:
                if (_token == '') {
                  Navigator.pushReplacementNamed(context, "/signin");
                } else {
                  _page = ProfileScreen(
                      isBackButton: false, token: _token, type: _type);
                  _pageName = 'account';
                }
                break;
              default:
                _page = HomeScreen();
                _pageName = 'home';
                break;
            }
          });
        },
      ),
    );
  }

  _getSolidIconState(String name) {
    if (name == _pageName) {
      return true;
    } else
      return false;
  }

  get _getHomeScaffold {
    List<Widget> widgetList = _homeScaffold();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widgetList.length,
          itemBuilder: (BuildContext context, int index) {
            return widgetList[index];
          }),
    );
  }

  _homeScaffold() {
    return <Widget>[
      _shopDetail,
      _getAppbarSection,
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleSpan(
            firstValue: LocaleKeys.top_categories.tr(),
            secondValue: '',
          ),
          ShowAllButton(onTap: () {
            Navigator.pushNamed(context, '/categories');
          }),
        ],
      ),
      _categorySection,
      _newsRoomSection,
      SizedBox(
        height: 20,
      ),
      TitleSpan(
        firstValue: LocaleKeys.popular_items.tr(),
        secondValue: '',
      ),
      SizedBox(
        height: 20,
      ),
      BlocConsumer<PopularFoodsBloc, PopularFoodsState>(
        builder: (context, state) {
          if (state is PopularFoodsListLoadSuccess) {
            // Show only first time loading
            _foodsList = state.foodsList;
            return PopularFoodList(
                foodsList: _foodsList,
                token: _token,
                logo: companies.length != 0 ? companies[0].logo! : '');
          }
          return Container();
        },
        listener: (context, state) {
          if (state is PopularFoodsListLoadSuccess) {}
        },
      ),
      SizedBox(
        height: 20,
      ),
      /*Ads(image: 'assets/images/ads_1.png'),
      SizedBox(height: 20),
      Ads(
        image: 'assets/images/ads_2.png',
      ),*/
      CarouselSliderWithIndicator(
        isAboveImage: false,
        isShowText: true,
        isAutoPlay: true,
        isShowLargeImage: false,
        isCenterText: false,
        height: 170.0,
        titleList: ['', ''],
        imgList: ['assets/images/ads_1.jpg', 'assets/images/ads_2.jpg'],
        idList: ['', ''],
        isNetworkType: false,
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleSpan(
            firstValue: LocaleKeys.new_arrivals.tr(),
            secondValue: '',
          ),
          ShowAllButton(onTap: () {
            List<String> arg = [
              '',
              _token,
              '',
              LocaleKeys.new_arrivals.tr(),
              'home'
            ];
            Navigator.pushNamed(context, '/search', arguments: arg);
          }),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      _latestFoodsSection,
    ];
  }

  _getUserValues() async {
    User? userValue = await _readUserValue();
    String? _loginType = await _readLoginValue();
    if (userValue != null) {
      setState(() {
        _user = userValue;
        _token = userValue.token!;
      });
    }

    if (_loginType != null) {
      setState(() {
        _type = _loginType;
      });
    }
    _initializeBlocs();
  }

  Future<String?> _readLoginValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loginType') != null) {
      String type = prefs.getString('loginType')!;
      return type;
    } else {
      return null;
    }
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

  get _newsRoomSection {
    return BlocConsumer<NewsBloc, NewsState>(builder: (context, state) {
      if (state is NewsListLoadInProgress) {
        return NewItemShimmer();
      }
      if (state is NewsListLoadSuccess) {
        // When API response has data

        if (state.newsList['result']['data'].length != 0 ||
            state.newsList['slider'] != null) {
          // get data for Image slide
          priorityList = List<News>.from(
                  state.newsList['slider'].map((i) => News.fromNewsLists(i)))
              .toList();

          List.generate(priorityList.length, (index) {
            if (!titleList.contains(priorityList[index].title)) {
              // Add titles for image slide
              titleList.add(priorityList[index].title);
              // Add images for image slide
              imgList.add(priorityList[index].newsImage);
              // Add id list to go to News Details bottom sheet
              idList.add(priorityList[index].slug!);
            }
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleSpan(
                    firstValue: LocaleKeys.newsroom.tr(),
                    secondValue: '',
                  ),
                  ShowAllButton(onTap: () {
                    Navigator.pushNamed(context, '/new');
                  }),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              CarouselSliderWithIndicator(
                isAboveImage: false,
                isShowText: true,
                isAutoPlay: false,
                isShowLargeImage: false,
                isCenterText: false,
                height: 200.0,
                titleList: titleList,
                imgList: imgList,
                idList: idList,
                isNetworkType: true,
              ),
            ],
          );
        }
      }
      return Container();
    }, listener: (context, state) {
      if (state is NewsListLoadSuccess) {
        setState(() {
          _newsTotal = int.parse(state.newsList['result']['total'].toString());
        });
      }
    });
  }

  void _initializeBlocs() {
    _categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    _categoriesBloc
      ..add(CategoriesListRequested(keyword: '', sort: '', order: ''));

    _foodsBloc = BlocProvider.of<PopularFoodsBloc>(context);
    _foodsBloc
      ..add(PopularFoodsLimitListRequested(
          limit: popularFoodsLimit, token: _token));

    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _newsBloc.add(NewsListRequested(
        keyword: '',
        sort: '',
        order: '',
        paginate: 1,
        page: 1,
        isFirstTime: false));

    _latestFoodsBloc = BlocProvider.of<FoodsBloc>(context);
    _latestFoodsBloc
      ..add(LatestFoodsListRequested(limit: latestFoodsLimit, token: _token));

    _notificationBloc = BlocProvider.of<NotificationsBloc>(context);
    _notificationBloc..add(NotificationsListRequested(token: _token));

    _voucherBloc = BlocProvider.of<VoucherBloc>(context);
    // Call API request to get Voucher list
    _voucherBloc.add(
      VoucherListRequested(
          token: _token,
          keyword: '',
          order: '',
          page: 1,
          paginate: 20,
          sort: '',
          isFirstTime: true),
    );

    _companiesBloc = BlocProvider.of<CompaniesBloc>(context);
    _companiesBloc.add(CompanyListRequested(keyword: '', order: '', sort: ''));
  }

  get _categorySection {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesListLoadInProgress) {
          return CategoriesLoadingListPage();
        }

        if (state is CategoriesListLoadSuccess) {
          // Show only first time loading

          List<Category> _data = state.categoriesList;
          return CategoryListWidget(
            categoriesList: _data,
            token: _token,
          );
        }
        return Container();
      },
      listener: (context, state) {
        if (state is CategoriesListLoadSuccess) {
          // Show only first time loading
          EasyLoading.dismiss();
        }
      },
    );
  }

  get _latestFoodsSection {
    return BlocConsumer<FoodsBloc, FoodsState>(
      builder: (context, state) {
        if (state is LatestFoodsListLoadSuccess) {
          // Show only first time loading
          _foodsList = state.foodsList;
          return LatestFoodSection(
              foodsList: _foodsList,
              token: _token,
              type: 'home',
              logo: companies.length != 0 ? companies[0].logo! : '');
        }
        return Container();
      },
      listener: (context, state) {},
    );
  }

  get _shopDetail {
    return BlocConsumer<CompaniesBloc, CompaniesState>(
      listener: (context, state) {
        if (state is CompaniesLoadingSuccessState) {
          if (state.companies.length > 0) {
            companies = state.companies;
            _saveShopInLocal(state.companies[0]);
          }
        }
      },
      builder: (context, state) {
        return Container();
      },
    );
  }

  _saveShopInLocal(Company company) async {
    final prefs = await SharedPreferences.getInstance();
    String _companyString = json.encode(company);
    prefs.setString('company', _companyString);
  }

  void firebaseCloudMessaging_Listeners() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('FCM message $message');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //RemoteNotification notification = message.notification;
      //AndroidNotification android = message.notification?.android;

      if (message.notification != null) {
        print(
            'On Message Listen ${message.notification!.title} \n${message.notification!.body}');

        showNotification(message.notification!.title.toString(),
            message.notification!.body.toString());

        /*showTitleNotification(
            '${message.notification.title} \n${message.notification.body}');*/
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _gotoNotificationScreen();
        });
      }
    });
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'my_notification', 'my_notification_name',
        channelDescription: 'my_notification_description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: kPriority.Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  void _onSelectNotification(String? payload) {
    _gotoNotificationScreen();
  }

  _gotoNotificationScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(),
      ),
    );
  }
}
