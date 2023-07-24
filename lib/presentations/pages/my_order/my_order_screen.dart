import 'package:bestcannedfood_ecommerce/blocs/my_order/my_order_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/not_order.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/my_orders_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/my_order/order_tabs.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderScreen extends StatefulWidget {
  final String? token;
  MyOrderScreen({
    Key? key,
    this.token,
  }) : super(key: key);

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  var currentIndex = 0;
  late TabController tabController;
  late MyOrdersBloc _myOrdersBloc;
  int page = 1;
  int totalCount = 0;
  int paginate = 20;
  String _status = '';
  String duration = 'last15days';
  List<MyOrder> myOrderList = [];
  int _activeTabIndex = 0;
  String _token = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_setActiveTabIndex);

    _myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);
  }

  void _setActiveTabIndex() {
    _activeTabIndex = tabController.index;
  }

  void _filterMyOrders(String value) {
    setState(() {
      duration = value;
    });
    _callMyOrdersFilteredList();
  }

  void _callMyOrdersFilteredList() {
    if (_activeTabIndex == 0) {
      _status = '';
    } else if (_activeTabIndex == 1) {
      _status = 'Order Received,Order Prepared,Order Picked up';
    } else if (_activeTabIndex == 2) {
      _status = 'Order Delivered';
    } else if (_activeTabIndex == 3) {
      _status = 'Order Canceled';
    }

    _myOrdersBloc
      ..add(
        MyOrdersListRequested(
            token: _token,
            status: _status,
            duration: duration,
            sort: 'id',
            order: 'DESC',
            paginate: paginate,
            page: page,
            isFirstTime: false),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return _myOrderScaffold;
        } else {
          return NoInternetWidget();
        }
      },
    );
  }

  get _myOrderScaffold {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomAppBar(
                leading: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  color: kButtonBackgroundColor.withOpacity(0.1),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: SvgPicture.asset(
                    "assets/icons/Back ICon.svg",
                    height: 15,
                  ),
                ),
                title:
                    '${LocaleKeys.my_orders.tr()} ($totalCount ${totalCount > 0 ? 'orders' : 'order'})',
                action: [
                  PopupMenuButton<String>(
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kButtonBackgroundColor.withOpacity(0.1),
                      ),
                      child: HeroIcon(
                        HeroIcons.sortAscending,
                        size: 18,
                      ),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'Last 15 days':
                          _filterMyOrders('last15days');
                          break;
                        case 'Last 30 days':
                          _filterMyOrders('last30days');
                          break;
                        case 'Last 6 months':
                          _filterMyOrders('last6months');
                          break;
                        case 'Last years':
                          _filterMyOrders('lastyear');
                          break;
                        default: // Nothing
                      }
                    },
                    elevation: 2.0,
                    offset: const Offset(0, 40),
                    itemBuilder: (BuildContext context) {
                      return {
                        'Last 15 days',
                        'Last 30 days',
                        'Last 6 months',
                        'Last year',
                      }.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice,
                            child: Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      _getLanguageText(choice),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      // All tab
                      _myOrdersBloc.add(
                        MyOrdersListRequested(
                            token: _token,
                            status: '',
                            duration: duration,
                            page: page,
                            paginate: paginate,
                            sort: 'id',
                            order: 'DESC',
                            isFirstTime: false),
                      );
                    } else if (index == 1) {
                      // Active tab
                      _myOrdersBloc.add(
                        MyOrdersListRequested(
                            token: _token,
                            status:
                                'Order Received,Order Prepared,Order Picked up',
                            duration: duration,
                            sort: 'id',
                            order: 'DESC',
                            page: page,
                            paginate: paginate,
                            isFirstTime: false),
                      );
                    } else if (index == 2) {
                      // Completed tab

                      _myOrdersBloc.add(
                        MyOrdersListRequested(
                            token: _token,
                            status: 'Order Delivered',
                            duration: duration,
                            page: page,
                            paginate: paginate,
                            sort: 'id',
                            order: 'DESC',
                            isFirstTime: false),
                      );
                    } else if (index == 3) {
                      // Canceled tab
                      _myOrdersBloc.add(
                        MyOrdersListRequested(
                            token: _token,
                            status: 'Order Canceled',
                            duration: duration,
                            page: page,
                            paginate: paginate,
                            sort: 'id',
                            order: 'DESC',
                            isFirstTime: false),
                      );
                    }
                  },
                  controller: tabController,
                  indicatorColor: kPrimaryColor,
                  indicatorWeight: 2.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: kPrimaryColor,
                  labelStyle: TextStyle(fontWeight: FontWeight.normal),
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        LocaleKeys.all_orders.tr(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        LocaleKeys.active.tr(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        LocaleKeys.completed.tr(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        LocaleKeys.canceled.tr(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ]),
            ),
            BlocConsumer<MyOrdersBloc, MyOrdersState>(
                builder: (context, state) {
              if (state is MyOrdersListLoadInProgress) {
                return MyOrdersLoadingPage();
              }
              if (state is MyOrdersListLoadSuccess) {
                if (state.myOrdersList['data'].length != 0) {
                  List<MyOrder> temp = List<MyOrder>.from(state
                      .myOrdersList['data']
                      .map((i) => MyOrder.fromMyOrdersList(i))).toList();

                  for (int i = 0; i < temp.length; i++) {
                    if (!myOrderList.contains(temp[i])) {
                      myOrderList.add(temp[i]);
                    }
                  }
                  return Expanded(
                    child: Container(
                      child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OrderTabs(
                                myOrderList: myOrderList,
                                tabName: 'all',
                                paginate: paginate,
                                page: page,
                                status: _status,
                                duration: duration,
                                token: _token),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OrderTabs(
                                myOrderList: myOrderList,
                                tabName: 'active',
                                paginate: paginate,
                                page: page,
                                status: _status,
                                duration: duration,
                                token: _token),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OrderTabs(
                                myOrderList: myOrderList,
                                tabName: 'completed',
                                paginate: paginate,
                                page: page,
                                status: _status,
                                duration: duration,
                                token: _token),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OrderTabs(
                                myOrderList: myOrderList,
                                tabName: 'canceled',
                                paginate: paginate,
                                page: page,
                                status: _status,
                                duration: duration,
                                token: _token),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  String _message = LocaleKeys.no_active_order_yet.tr();
                  if (_activeTabIndex == 2) {
                    _message = LocaleKeys.no_completed_order_yet.tr();
                  } else if (_activeTabIndex == 3) {
                    _message = LocaleKeys.no_canceled_order_yet.tr();
                  }

                  return Expanded(
                    child: Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: NotOrderScreen(
                            message: _message,
                          )),
                    ),
                  );
                }
              }
              return Container();
            }, listener: (context, state) {
              if (state is MyOrdersListLoadSuccess) {
                setState(() {
                  totalCount = state.myOrdersList['total'];
                });
              }

              if (state is MyOrdersListLoadFailure) {
                var message =
                    state.message.toString().replaceAll('Exception: ', '');
                showErrorMessage(message);
                if (message.toString() == 'Unauthenticated.') {
                  _signOutAccount();
                }
              }
            })
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      String data = ModalRoute.of(context)!.settings.arguments as String;
      setState(() {
        _token = data;
      });

      //Call API request to get My Orders list
      _myOrdersBloc.add(
        MyOrdersListRequested(
            token: _token,
            status: '',
            duration: duration,
            page: page,
            paginate: paginate,
            sort: 'id',
            order: 'DESC',
            isFirstTime: true),
      );
    }
    super.didChangeDependencies();
  }

  Future<void> _signOutAccount() async {
    showErrorMessage('Unauthenticated.');

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushReplacementNamed(context, '/home');
  }

  String _getLanguageText(String choice) {
    switch (choice) {
      case 'Last 15 days':
        return LocaleKeys.last_15_days.tr();
      case 'Last 30 days':
        return LocaleKeys.last_30_days.tr();
      case 'Last 6 months':
        return LocaleKeys.last_6_months.tr();
      case 'Last year':
        return LocaleKeys.last_year.tr();
      default:
        return '';
    }
  }
}
