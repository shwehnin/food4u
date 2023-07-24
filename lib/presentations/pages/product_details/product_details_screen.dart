import 'dart:convert';

import 'package:bestcannedfood_ecommerce/blocs/foods/foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/reviews/reviews_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/hex_color.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/model/promotion_discount.dart';
import 'package:bestcannedfood_ecommerce/model/reviews.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/image_slider.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/label_check_box.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/product_details_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/review/review_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/color_dot.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/discount.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/size_card.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/radio_list_card.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/video.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/review/list.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'
    as kYoutubePlayer;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int foodId = 0;
  FoodMaster _foodMaster = new FoodMaster();
  late FoodsBloc _foodsBloc;
  late ReviewsBloc _reviewsBloc;
  var count = 0;
  Map<String, dynamic> _addOnKeys = {};
  Map<String, dynamic> _addOnvalues = {};
  User? _user;
  Company? _company;
  double deliveryTime = 0.0;

  @override
  void initState() {
    _getUserValues();
    _getCompanyValues();
    super.initState();
    _foodsBloc = BlocProvider.of<FoodsBloc>(context);
    _reviewsBloc = BlocProvider.of<ReviewsBloc>(context);
  }

  String token = '';
  int _price = 0;
  int _choicePrice = 0;
  int _addOnPrice = 0;
  int _choiceValue = -1;

  List<String> imgList = [];
  String _id = '';
  String _size = '';
  String _spicyLevel = '';
  List<int> _choiceOfPrice = [];
  int _reviewPage = 0;
  int _selectedColorIndex = -1;
  List<String> _colorList = [];
  List<Reviews> _reviewList = [];

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      FoodMaster data =
          ModalRoute.of(context)!.settings.arguments as FoodMaster;
      setState(() {
        foodId = int.parse(data.id!);
        _id = data.id!;
      });
      _foodsBloc.add(FoodsDetailRequested(id: _id));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backtoHome(),
      child: ConnectivityBuilder(
        builder: (context, isConnected, status) {
          if (isConnected.toString() != 'false') {
            return _foodDetailsContainer;
          } else {
            return NoInternetWidget();
          }
        },
      ),
    );
  }

  get _foodDetailsContainer {
    return Container(
      child: BlocConsumer<FoodsBloc, FoodsState>(
        builder: (context, state) {
          if (state is FoodsDetailsListLoadInProgress) {
            return ProductDetailsShimmer();
          }

          if (state is FoodsDetailListLoadSuccess) {
            // Show only first time loading
            _foodMaster = state.foodMaster;
            _insertImagesToList();
            _insertChoiceOfPrices();
            return _foodDetailScaffold;
          }
          return Scaffold(
            backgroundColor: kPrimaryLightColor,
          );
        },
        listener: (context, state) {
          if (state is FoodsDetailsListLoadFailure) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state is FoodsDetailListLoadSuccess) {
            _foodMaster = state.foodMaster;

            Map<String, dynamic> addOnData = {
              _foodMaster.addOnA.toString(): false,
              _foodMaster.addOnB.toString(): false,
              _foodMaster.addOnC.toString(): false,
              _foodMaster.addOnD.toString(): false,
              _foodMaster.addOnE.toString(): false,
            };
            Map<String, dynamic> addOnDataValues = {
              _foodMaster.addOnA.toString(): _foodMaster.addOnAPrice,
              _foodMaster.addOnB.toString(): _foodMaster.addOnBPrice,
              _foodMaster.addOnC.toString(): _foodMaster.addOnCPrice,
              _foodMaster.addOnD.toString(): _foodMaster.addOnDPrice,
              _foodMaster.addOnE.toString(): _foodMaster.addOnEPrice,
            };

            setState(() {
              _price = _foodMaster.unitPrice!;
              _addOnKeys.addAll(addOnData);
              _addOnvalues.addAll(addOnDataValues);
            });
          }
        },
      ),
    );
  }

  get _foodDetailScaffold {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            Stack(
              children: [
                CarouselSliderWithIndicator(
                  imgList: imgList,
                  isShowLargeImage: true,
                  isCenterText: false,
                  height: 300.0,
                  isAboveImage: true,
                  isShowText: false,
                  isAutoPlay: true,
                  isNetworkType: true,
                ),
                Positioned(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: CustomAppBar(
                      leading: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        color: kPrimaryLightColor,
                        padding: EdgeInsets.zero,
                        onPressed: () => _backtoHome(),
                        child: SvgPicture.asset(
                          "assets/icons/Back ICon.svg",
                          height: 15,
                        ),
                      ),
                      title: '',
                      action: [
                        MaterialButton(
                          minWidth: 40,
                          height: 40,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          color: kPrimaryLightColor,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (token != '') {
                              _foodsBloc.add(
                                FoodFavouriteCreateRequested(
                                    token: token,
                                    foodId: foodId,
                                    slug: _foodMaster.slug!,
                                    context: context,
                                    type: 'detail'),
                              );
                            } else {
                              Navigator.pushNamed(context, '/signin');
                            }
                          },
                          child: HeroIcon(
                            HeroIcons.heart,
                            size: 18,
                            color: kHeartColor,
                            solid: _foodMaster.isFavourite!,
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          height: 40,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          color: kPrimaryLightColor,
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              SocialShare.shareOptions(_foodMaster.url!),
                          child: HeroIcon(
                            HeroIcons.share,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                _foodMaster.foodName.toString() + ' (${_foodMaster.itemCode})',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, height: 1.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          HeroIcon(
                            HeroIcons.star,
                            solid: true,
                            size: 17,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${_foodMaster.totalStars.toString()} (${double.parse(_foodMaster.feedbackCount.toString())})",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          HeroIcon(
                            HeroIcons.tag,
                            solid: true,
                            size: 17,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _foodMaster.subCategory!.subCategory.toString(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      _foodMaster.eptTime != 0
                          ? Row(
                              children: [
                                HeroIcon(
                                  HeroIcons.truck,
                                  solid: true,
                                  size: 17,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // _foodMaster.eptTime! > 24
                                //     ? Text(
                                //         '${_foodMaster.eptTime! / 24}' +
                                //             ' $deliveryDayText',
                                //         style: TextStyle(
                                //           fontSize: 12,
                                //         ),
                                //       )
                                //     : Text('${_foodMaster.eptTime.toString()}' +
                                //         '$deliveryTimeText'),
                                _deliveryFormat()
                              ],
                            )
                          : Container(),
                    ],
                  ),

                  _foodMaster.promotionDiscount!.length != 0
                      ? _getPromotionList(_foodMaster.promotionDiscount!)
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),

                  _getColorSection,

                  SizedBox(
                    height: 10,
                  ),

                  SizeCard(
                    sizes: _foodMaster.sizes!,
                    onSelect: (String param) {
                      setState(() {
                        _size = param;
                      });
                    },
                  ),

                  _foodMaster.spicyLevels!.length != 0 &&
                          _foodMaster.spicyLevels!.length != 1
                      ? Column(
                          children: [
                            SizedBox(height: 10),
                            RadioListCard(
                              title: LocaleKeys.choose_other.tr(),
                              valueList: _foodMaster.spicyLevels!,
                              subLabelList: [],
                              onSelect: (String param) {
                                setState(() {
                                  _spicyLevel = _foodMaster
                                      .spicyLevels![int.parse(param)];
                                });
                              },
                              type: 'radio',
                            )
                          ],
                        )
                      : Container(),

                  // ignore: unnecessary_null_comparison
                  _getChoiceOfWidget,

                  // ignore: unnecessary_null_comparison
                  _foodMaster.addOnA != null ||
                          _foodMaster.addOnB != null ||
                          _foodMaster.addOnC != null ||
                          _foodMaster.addOnD != null ||
                          _foodMaster.addOnE != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Choose of add-on for ${_foodMaster.foodName.toString()}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: _addOnKeys.keys.map(
                                      (String key) {
                                        return key.toString() != 'null'
                                            ? Row(
                                                children: [
                                                  Container(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              70,
                                                      height: 35,
                                                      child: LabeledCheckbox(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        label: key,
                                                        fontSize: 14,
                                                        subLabel:
                                                            'K ${NumberFormat.decimalPattern().format(_addOnvalues[key])}',
                                                        value: _addOnKeys[key],
                                                        onTap: (dynamic value) {
                                                          setState(
                                                            () {
                                                              _addOnKeys[key] =
                                                                  value;
                                                              if (value) {
                                                                _addOnPrice +=
                                                                    _addOnvalues[
                                                                            key]
                                                                        as int;
                                                              } else {
                                                                _addOnPrice -=
                                                                    _addOnvalues[
                                                                            key]
                                                                        as int;
                                                              }
                                                            },
                                                          );
                                                        },
                                                        activeColor:
                                                            kPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      },
                                    ).toList(),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),

                  _foodMaster.description != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Html(
                                data: """${_foodMaster.description}""",
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10),

                  _foodMaster.youtubeUrl != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: YoutubeVideoWidget(
                            controller: YoutubePlayerController(
                              initialVideoId:
                                  kYoutubePlayer.YoutubePlayer.convertUrlToId(
                                          _foodMaster.youtubeUrl!)
                                      .toString(),
                              params: YoutubePlayerParams(
                                // Defining custom playlist
                                startAt: Duration(seconds: 0),
                                showControls: true,
                                autoPlay: false,
                                showFullscreenButton: true,
                              ),
                            ),
                          ),
                        )
                      : Container(),

                  _foodMaster.facebookUrl != null ||
                          _foodMaster.instagramUrl != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _getFacebookInstagramVideoWidget,
                        )
                      : Container(),

                  SizedBox(height: 10),
                  _addReviewSection,
                ],
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            color: kPrimaryLightColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      'K ' +
                          NumberFormat.decimalPattern()
                              .format(_price + _addOnPrice + _choicePrice),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  _foodMaster.poUnit != ''
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'per ${_foodMaster.poUnit}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        )
                      : Container(),
                ],
              ),
              MaterialButton(
                color: kPrimaryColor,
                child: Row(
                  children: [
                    HeroIcon(
                      HeroIcons.shoppingBag,
                      color: kPrimaryLightColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      LocaleKeys.add_to_basket.tr(),
                      style: TextStyle(
                        color: kPrimaryLightColor,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                onPressed: () => _callAddToCart(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _addReviewSectionHeader {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              HeroIcon(
                HeroIcons.star,
                solid: true,
                size: 24,
                color: kGoldColor,
              ),
              SizedBox(width: 5),
              Text(
                "${_foodMaster.totalStars.toString()} (${_foodMaster.feedbackCount.toString()} reviews)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () {
                token != ''
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddReviewScreen(
                                  foodId: foodId,
                                  slug: _id,
                                  token: token,
                                  foodName: _foodMaster.foodName.toString(),
                                )),
                      )
                    : Navigator.pushReplacementNamed(context, '/signin');
              },
              child: Row(
                children: [
                  HeroIcon(
                    HeroIcons.pencilAlt,
                    size: 15,
                    color: kBlackColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      LocaleKeys.add_review.tr(),
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  get _addReviewSection {
    return Container(
      child: Column(
        children: [
          _addReviewSectionHeader,
          BlocConsumer<ReviewsBloc, ReviewsState>(
            builder: (context, state) {
              if (state is ReviewsListLoadSuccess) {
                _reviewList = state.data;
                if (_reviewList.length != 0) {
                  return _getReviewList(_reviewList);
                } else {
                  return _getEmptyReview;
                }
              }
              return Container();
            },
            listener: (context, state) {
              if (state is ReviewsListLoadSuccess) {
                setState(() {
                  _foodMaster.feedbackCount = state.data.length;
                });
              }
            },
          )
        ],
      ),
    );
  }

  _getPromotionList(List<PromotionDiscount> list) {
    return Column(
      children: [
        for (int index = 0; index < list.length; index++)
          DateTime.parse(_foodMaster.promotionDiscount![index].effectEndPlanDate
                          .toString())
                      .difference(DateTime.now())
                      .inDays !=
                  0
              ? Discount(
                  title: list[index].strategy.toString(),
                  discount: list[index].discountAmount != null
                      ? '${list[index].discountAmount}% \n OFF'
                      : 'Buy ${list[index].buyCounts} \n Get ${list[index].getCounts}',
                  promoFlag: list[index].promoCodeFlag.toString(),
                  holidayCampaign: list[index].holidayCampaign.toString(),
                  expireDate:
                      'Expires in ${DateTime.parse(_foodMaster.promotionDiscount![0].effectEndPlanDate.toString()).difference(DateTime.now()).inDays} days',
                  usage: list[index].oneTimeFlag.toString() == 'Yes'
                      ? 'Only 1-time use'
                      : 'Unlimited time',
                  discount1: list[index].discountAmount != null
                      ? '${list[index].discountAmount}'
                      : '',
                  fromBuyCounts: list[index].fromBuyCounts.toString(),
                  toBuyCounts: list[index].toBuyCounts.toString(),
                  discount2: list[index].discount2 != null
                      ? '${list[index].discount2}'
                      : '',
                  fromBuyCounts2: list[index].fromBuyCounts2 != null
                      ? list[index].fromBuyCounts2.toString()
                      : '',
                  toBuyCounts2: list[index].toBuyCounts2 != null
                      ? list[index].toBuyCounts2.toString()
                      : '',
                  discount3: list[index].discount3 != null
                      ? '${list[index].discount3}'
                      : '',
                  fromBuyCounts3: list[index].fromBuyCounts3 != null
                      ? list[index].fromBuyCounts3.toString()
                      : '',
                  toBuyCounts3: list[index].toBuyCounts3 != null
                      ? list[index].toBuyCounts3.toString()
                      : '',
                  discount4: list[index].discount4 != null
                      ? '${list[index].discount4}'
                      : '',
                  fromBuyCounts4: list[index].fromBuyCounts4 != null
                      ? list[index].fromBuyCounts4.toString()
                      : '',
                  toBuyCounts4: list[index].toBuyCounts4 != null
                      ? list[index].toBuyCounts4.toString()
                      : '',
                  limit: list[index].limitOrders != 0
                      ? list[index].limitOrders.toString()
                      : '',
                  unitPrice: _foodMaster.unitPrice,
                  poUnit: _foodMaster.poUnit,
                  unitConversion: _foodMaster.unitValue != 0
                      ? '1 ${_foodMaster.whUnit} ${_foodMaster.unitValue} ${_foodMaster.poUnit} '
                      : '',
                )
              : Container()
      ],
    );
  }

  _insertImagesToList() {
    if (_foodMaster.imageA != null &&
        !imgList.contains(_foodMaster.imageA.toString())) {
      imgList.add(_foodMaster.imageA.toString());
    } else {
      // imgList.add(kLogoImageUrl);

      if (_company != null && !imgList.contains(_company!.logo.toString()))
        imgList.add(_company!.logo.toString());
    }
    if (_foodMaster.imageB != null &&
        !imgList.contains(_foodMaster.imageB.toString())) {
      imgList.add(_foodMaster.imageB.toString());
    }
    if (_foodMaster.imageC != null &&
        !imgList.contains(_foodMaster.imageC.toString())) {
      imgList.add(_foodMaster.imageC.toString());
    }
    if (_foodMaster.imageD != null &&
        !imgList.contains(_foodMaster.imageD.toString())) {
      imgList.add(_foodMaster.imageD.toString());
    }
    if (_foodMaster.imageE != null &&
        !imgList.contains(_foodMaster.imageE.toString())) {
      imgList.add(_foodMaster.imageE.toString());
    }
  }

  void _insertChoiceOfPrices() {
    _choiceOfPrice.add(_foodMaster.choiceOfAPrice!);
    _choiceOfPrice.add(_foodMaster.choiceOfBPrice!);
    _choiceOfPrice.add(_foodMaster.choiceOfCPrice!);
    _choiceOfPrice.add(_foodMaster.choiceOfDPrice!);
  }

  _callAddToCart() {
    if (token == '') {
      Navigator.pushReplacementNamed(context, '/signin');
    } else if (_size == '' &&
        _foodMaster.sizes!.length != 0 &&
        _foodMaster.sizes!.length != 1) {
      EasyLoading.showError(
          'Please choose service for ${_foodMaster.foodName!}.',
          duration: Duration(seconds: 3));
    } else if (_spicyLevel == '' &&
        _foodMaster.spicyLevels!.length != 0 &&
        _foodMaster.spicyLevels!.length != 1) {
      EasyLoading.showError('Please choose other for ${_foodMaster.foodName!}.',
          duration: Duration(seconds: 3));
    } else if (_selectedColorIndex == -1 && _colorList.length != 0) {
      EasyLoading.showError('Please choose color.',
          duration: Duration(seconds: 3));
    } else if (token != '') {
      if (_foodMaster.sizes!.length == 1) _size = _foodMaster.sizes![0];

      if (_foodMaster.spicyLevels!.length == 1)
        _spicyLevel = _foodMaster.spicyLevels![0];

      _foodsBloc.add(
        FoodsAddToCartRequested(
          foodId: foodId,
          orderQty: 1,
          size: _size,
          spicy: _spicyLevel,
          choiceOfA: _choiceValue == 0 ? true : false,
          choiceOfB: _choiceValue == 1 ? true : false,
          choiceOfC: _choiceValue == 2 ? true : false,
          choiceOfD: _choiceValue == 3 ? true : false,
          addOnA: _addOnKeys[_foodMaster.addOnA.toString()],
          addOnB: _addOnKeys[_foodMaster.addOnB.toString()],
          addOnC: _addOnKeys[_foodMaster.addOnC.toString()],
          addOnD: _addOnKeys[_foodMaster.addOnD.toString()],
          addOnE: _addOnKeys[_foodMaster.addOnE.toString()],
          token: token,
          itemColor:
              _selectedColorIndex != -1 ? _colorList[_selectedColorIndex] : '',
          context: context,
        ),
      );
    }
  }

  _getUserValues() async {
    User? userValue = await _readUserValue();
    if (userValue != null) {
      setState(() {
        _user = userValue;
        token = userValue.token!;
      });

      _reviewsBloc.add(ReviewsListRequested(
          sort: '',
          order: '',
          paginate: 20,
          page: _reviewPage,
          foodId: foodId,
          token: token));
    } else {
      setState(() {
        token = '';
      });
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

  get _getFacebookInstagramVideoWidget {
    String url = '';
    if (_foodMaster.facebookUrl != null) {
      url = _foodMaster.facebookUrl!;
    } else {
      url = _foodMaster.instagramUrl!;
    }
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Click to view video',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
      onTap: () => launchSocial(url, url),
    );
  }

  _getReviewList(List<Reviews> reviewList) {
    return Container(
      height: reviewList.length * 160,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ReviewListItem(
            reviews: reviewList[index],
            token: token,
            id: _foodMaster.id!,
            user: _user,
            page: _reviewPage,
          );
        },
        itemCount: reviewList.length,
      ),
    );
  }

  get _getEmptyReview {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.star,
            solid: true,
            size: 32,
            color: kGoldColor,
          ),
          Text(LocaleKeys.no_review.tr())
        ],
      ),
    );
  }

  get _getColorSection {
    if (_foodMaster.itemColor != null)
      _colorList = _foodMaster.itemColor!.split(',');

    if (_colorList.length != 0) {
      return Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.choose_color.tr(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: <Widget>[
                    for (int i = 0; i < _colorList.length; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedColorIndex = i;
                          });
                        },
                        child: ColorDot(
                          color: HexColor(_colorList[i]),
                          isSelected: _selectedColorIndex == i ? true : false,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
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

  _backtoHome() {
    _foodsBloc..add(InitialFoodsRequested());
    Navigator.pushReplacementNamed(context, '/home');
  }

  _deliveryFormat() {
    if (_foodMaster.eptTime! > 24) {
      return Text(
        '${_foodMaster.eptTime! / 24}' + ' $deliveryDayText',
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else if (_foodMaster.eptTime! > 365) {
      return Text(
        '${_foodMaster.eptTime! / 365}' + ' $deliveryYearText',
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else {
      return Text('${_foodMaster.eptTime.toString()}' + '$deliveryTimeText');
    }
  }

  Widget get _getChoiceOfWidget {
    List<String> valueList = [];
    List<String> subLabelList = [];

    if (_foodMaster.choiceOfA != null) {
      valueList.add(_foodMaster.choiceOfA.toString());
      subLabelList.add(_foodMaster.choiceOfAPrice.toString());
    }
    if (_foodMaster.choiceOfB != null) {
      valueList.add(_foodMaster.choiceOfB.toString());
      subLabelList.add(_foodMaster.choiceOfBPrice.toString());
    }
    if (_foodMaster.choiceOfC != null) {
      valueList.add(_foodMaster.choiceOfC.toString());
      subLabelList.add(_foodMaster.choiceOfCPrice.toString());
    }
    if (_foodMaster.choiceOfD != null) {
      valueList.add(_foodMaster.choiceOfD.toString());
      subLabelList.add(_foodMaster.choiceOfDPrice.toString());
    }

    return valueList.length != 0
        ? Column(
            children: [
              RadioListCard(
                title: 'Choice of ${_foodMaster.foodName}',
                valueList: valueList,
                subLabelList: subLabelList,
                onSelect: (String param) {
                  setState(() {
                    _choicePrice = _choiceOfPrice[int.parse(param)];
                    _choiceValue = int.parse(param);
                  });
                },
                type: 'radio',
              ),
              SizedBox(height: 10),
            ],
          )
        : Container();
  }
}
