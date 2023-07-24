import 'package:bestcannedfood_ecommerce/blocs/my_order/my_order_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/delivery_location.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/not_order.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/personal_profile.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/profile_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/my_order/order_tabs.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isBackButton;
  final String? token;
  final String? type;
  const ProfileScreen(
      {Key? key, required this.isBackButton, this.token, this.type})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;
  late MyOrdersBloc _myOrdersBloc;
  late User profile;
  int page = 1;
  int paginate = 20;
  List<MyOrder> myOrderList = [];

  @override
  void initState() {
    super.initState();

    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    // Call API request to get Profile
    _profileBloc.add(
      ProfileRequested(token: widget.token!, isFirstTime: true),
    );

    _myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);
    //Call API request to get My Orders list
    _myOrdersBloc.add(
      MyOrdersListRequested(
          token: widget.token!,
          status: '',
          duration: 'last15days',
          order: 'DESC',
          page: page,
          paginate: paginate,
          sort: 'id',
          isFirstTime: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      builder: (BuildContext context, state) {
        if (state is ProfileLoadInProgress) {
          return ProfileLoadingPage();
        }
        if (state is ProfileLoadSuccess) {
          return _profileScaffold;
        }
        return Container();
      },
      listener: (BuildContext context, state) {
        if (state is ProfileLoadFailure) {
          var message = state.message.toString().replaceAll('Exception: ', '');
          showErrorMessage(message);
          if (message.toString() == 'Unauthenticated.') {
            _signOutAccount();
          }
        }
      },
    );
  }

  get _profileScaffold {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            _getAppBar,
            _getProfileSection,
            _getRecentOrderTitle,
            _getRecentOrders,
          ],
        ),
      ),
    );
  }

  get _getRecentOrderTitle {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(LocaleKeys.recent_orders.tr(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: const EdgeInsets.only(right: 3.0),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/my_order',
                    arguments: widget.token);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      LocaleKeys.show_all.tr(),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  get _getProfileSection {
    return BlocConsumer<ProfileBloc, ProfileState>(builder: (context, state) {
      // Getting Profile page information
      if (state is ProfileLoadInProgress) {
        return ProfileLoadingPage();
      }
      if (state is ProfileLoadSuccess) {
        // Get profile information
        profile = User(
          customerName: state.profile.customerName,
          email: state.profile.email,
          deliveryLocation: state.profile.deliveryLocation,
          phoneVerified: state.profile.phoneVerified,
          fcmToken: state.profile.fcmToken,
          deliAreasId: state.profile.deliAreasId,
          phone: state.profile.phone,
        );

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: _getProfileList(profile),
        );
      }

      // Updating Profile information
      if (state is UpdateProfileInformationLoadInProgress) {
        EasyLoading.show(status: 'loading...');
      }
      if (state is UpdateProfileInformationLoadSuccess) {
        if (state.updatedProfile['success']) {
          EasyLoading.showSuccess(LocaleKeys.updated_profile.tr());
          // Get Profile information after updating
          BlocProvider.of<ProfileBloc>(context).add(
            ProfileRequested(token: widget.token!, isFirstTime: true),
          );
        }
      }

      if (state is UpdateProfileInformationLoadFailure) {
        // Get Profile information after updating
        BlocProvider.of<ProfileBloc>(context).add(
          ProfileRequested(token: widget.token!, isFirstTime: true),
        );
      }

      // Updating Profile password
      if (state is UpdateProfilePasswordLoadInProgress) {
        EasyLoading.show(status: 'loading...');
      }

      if (state is UpdateProfilePasswordLoadFailure) {
        // Get Profile information after updating
        BlocProvider.of<ProfileBloc>(context).add(
          ProfileRequested(token: widget.token!, isFirstTime: true),
        );
      }

      return Container();
    }, listener: (context, state) {
      if (state is UpdateProfilePasswordLoadSuccess) {
        BlocProvider.of<ProfileBloc>(context).add(
          ProfileRequested(token: widget.token!, isFirstTime: true),
        );
      }
      if (state is UpdateProfileInformationLoadSuccess) {
        if (state.updatedProfile['success']) {
          EasyLoading.showSuccess(LocaleKeys.updated_profile.tr());
          BlocProvider.of<ProfileBloc>(context).add(
            ProfileRequested(token: widget.token!, isFirstTime: true),
          );
        }
      }
    });
  }

  Widget _getProfileList(User profileData) {
    // Recent Orders existed
    return _profileInfo(profileData);
  }

  get _getRecentOrders {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocConsumer<MyOrdersBloc, MyOrdersState>(
        builder: (context, state) {
          if (state is MyOrdersListLoadSuccess) {
            if (state.myOrdersList['data'].length != 0) {
              myOrderList = List<MyOrder>.from(state.myOrdersList['data']
                  .map((i) => MyOrder.fromMyOrdersList(i))).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Call for Recent Orders

                  OrderTabs(
                    myOrderList: myOrderList,
                    tabName: 'all',
                    paginate: paginate,
                    page: page,
                    status: '',
                    duration: '',
                    token: widget.token!,
                    route: 'profile',
                  ),
                ],
              );
            }
            // No Recent Orders
            else {
              return Container(
                height: 300,
                child: NotOrderScreen(message: LocaleKeys.no_order_yet.tr()),
              );
            }
          }
          return Container();
        },
        listener: (context, state) {},
      ),
    );
  }

  _profileInfo(User profileData) {
    return Container(
      child: Column(
        children: [
          DeliveryLocation(
              token: widget.token!,
              customerName: profileData.customerName,
              // ignore: unnecessary_null_comparison
              deliveryLocation: profileData.deliveryLocation != null
                  ? profileData.deliveryLocation
                  : '',
              deliAreasId: profileData.deliAreasId,
              email: profileData.email),
          SizedBox(
            height: 20,
          ),
          PersonalProfile(
            token: widget.token!,
            customerName: profileData.customerName,
            deliveryLocation: profileData.deliveryLocation,
            deliAreasId: profileData.deliAreasId,
            email: profileData.email,
            isVerified: profileData.phoneVerified,
            phone: profileData.phone.toString(),
            loginType: widget.type,
          ),
        ],
      ),
    );
  }

  get _getAppBar {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10.0),
      child: widget.isBackButton
          ? CustomAppBar(
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
              title: LocaleKeys.manage_profile.tr(),
              action: [])
          : Text(
              LocaleKeys.manage_profile.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    );
  }

  Future<void> _signOutAccount() async {
    showErrorMessage('Unauthenticated.');

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushReplacementNamed(context, '/home');
  }
}
