import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_event.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_state.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/favourite.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/favourite_list_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/favorite/favorite_item.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/loadmore_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key, this.token, required this.isShowAppbar})
      : super(key: key);
  final String? token;
  final bool isShowAppbar;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavouritesBloc _favouritesBloc;
  List<Favourite> favourites = [];
  late int page = 1;
  int totalCount = 0;
  late bool isFavourite = true;
  Company? _company;

  @override
  void initState() {
    super.initState();
    _getCompanyValues();
    _favouritesBloc = BlocProvider.of<FavouritesBloc>(context);
    _favouritesBloc.add(
      FavouritesListRequested(
        keyword: '',
        order: '',
        page: page,
        paginate: 20,
        sort: '',
        token: widget.token,
        isFirstTime: true,
      ),
    );
    EasyLoading.dismiss();
  }

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavouritesBloc, FavouritesState>(
      builder: (context, state) {
        if (state is FavouriteRemoveSuccessState) {
          String message = state.message;
          if (message != '') {
            EasyLoading.showSuccess(message,
                duration: Duration(milliseconds: 1000));
            _favouritesBloc.add(
              FavouritesListRequested(
                keyword: '',
                order: '',
                page: page,
                paginate: 20,
                sort: '',
                token: widget.token,
                isFirstTime: false,
              ),
            );
          }
        }
        if (state is FavouritesLoadingState) {
          return FavouriteListLoading();
        }
        if (state is FavouritesLoadingSuccessState) {
          if (favourites.length != 0) {
            List<Favourite> temp = List<Favourite>.from(state.favourites['data']
                .map((i) => Favourite.fromFavouritesList(i))).toList();

            for (int i = 0; i < temp.length; i++) {
              if (!favourites.contains(temp[i])) {
                favourites.add(temp[i]);
              }
            }
          } else {
            favourites = List<Favourite>.from(state.favourites['data']
                .map((i) => Favourite.fromFavouritesList(i))).toList();
          }

          return totalCount != 0
              ? Scaffold(
                  backgroundColor: kPrimaryLightColor,
                  body: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.isShowAppbar ? _getAppBarSection : Container(),
                          !widget.isShowAppbar
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10.0),
                                  child: Text(
                                    '${LocaleKeys.favourite_items.tr()} (${totalCount} Items)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  child: LoadMore(
                                    textBuilder: (status) {
                                      if (status == LoadMoreStatus.nomore &&
                                          page != 1) {
                                        showErrorMessage('No records found.');
                                        return "";
                                      }
                                      return DefaultLoadMoreTextBuilder.english(
                                          status);
                                    },
                                    isFinish: (favourites.length % 20) != 0,
                                    onLoadMore: _loadMore,
                                    child: _getFavouriteList(favourites),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : _getEmptyFavourite;
        }
        return Container();
      },
      listener: (context, state) {
        if (state is FavouritesLoadingSuccessState) {
          setState(() {
            totalCount = state.favourites['total'];
          });
        }

        if (state is FavouriteRemoveSuccessState) {
          setState(() {
            favourites.clear();
          });
        }

        if (state is FavouritesFailureState) {
          EasyLoading.dismiss();
          var message = state.message.toString().replaceAll('Exception: ', '');
          showErrorMessage(message);
          if (message.toString() == 'Unauthenticated.') {
            _signOutAccount();
          }
        }
      },
    );
  }

  Widget _getFavouriteList(List<Favourite> favouriteData) {
    return favouriteData.length > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: favouriteData.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FavoriteItem(
                  foodMaster: favouriteData[index].foodMaster!,
                  token: widget.token!,
                  logo: _company != null ? _company!.logo! : '',
                ),
              );
            },
          )
        : _getEmptyFavourite;
  }

  get _getEmptyFavourite {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomAppBar(
                  title: '${LocaleKeys.favourite_items.tr()} (0 item)',
                  action: [],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/icons/nofavourite.json',
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: 300),
                      Text(
                        LocaleKeys.no_favourite_items_yet.tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Text(
                          LocaleKeys.start_shopping.tr(),
                          style: TextStyle(
                            color: kPrimaryLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      page++;
    });
    _favouritesBloc.add(
      FavouritesListRequested(
        keyword: '',
        order: '',
        page: page,
        paginate: 20,
        sort: '',
        token: widget.token,
        isFirstTime: false,
      ),
    );
    return true;
  }

  Future<void> _signOutAccount() async {
    showErrorMessage('Unauthenticated.');

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushReplacementNamed(context, '/home');
  }

  get _getAppBarSection {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: Text(
        '${LocaleKeys.favourite_items.tr()} ($totalCount Items)',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: kBlackColor),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: kButtonBackgroundColor.withOpacity(0.1),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/icons/Back ICon.svg",
            height: 15,
            color: kBlackColor,
          ),
        ),
      ),
      actions: [],
    );
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
}
