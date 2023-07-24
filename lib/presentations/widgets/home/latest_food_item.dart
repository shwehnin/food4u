import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/foods/foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

class LatestFoodItem extends StatefulWidget {
  final FoodMaster foodMaster;
  final String token;
  final String logo;
  final String type;

  const LatestFoodItem(
      {Key? key,
      required this.foodMaster,
      required this.token,
      required this.logo,
      required this.type})
      : super(key: key);

  @override
  _LatestFoodItemState createState() => _LatestFoodItemState();
}

class _LatestFoodItemState extends State<LatestFoodItem> {
  List<String> imgList = [];
  late FoodsBloc _foodsBloc;

  @override
  void initState() {
    super.initState();
    _insertImagesToList();
    _foodsBloc = BlocProvider.of<FoodsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(15),
                    image: widget.foodMaster.imageA != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              widget.foodMaster.imageA!,
                            ),
                          )
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              kLogoImageUrl,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: _getFavouriteButton(),
                ),
                widget.foodMaster.promotionDiscount!.length != 0
                    ? Positioned(
                        bottom: 5,
                        left: 5,
                        right: widget.foodMaster.promotionDiscount![0].strategy
                                        .toString()
                                        .length >
                                    20 &&
                                MediaQuery.of(context).size.width < 500
                            ? 5
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: kBlackColor,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Text(
                            widget.foodMaster.promotionDiscount![0].strategy
                                        .toString() !=
                                    'Range Offer'
                                ? widget
                                    .foodMaster.promotionDiscount![0].strategy
                                    .toString()
                                : 'Wholesale Offer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: kPrimaryLightColor, fontSize: 10),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: Text(
              widget.foodMaster.foodName.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: false,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Row(
            children: [
              HeroIcon(
                HeroIcons.star,
                solid: true,
                size: 17,
              ),
              SizedBox(width: 5),
              Text(
                "${widget.foodMaster.totalStars.toString()} (${widget.foodMaster.feedbackCount})",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Row(
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
              //changed hr,day,year
              _deliveryFormat()
            ],
          ),
          Text(
            "K ${currencyFormat.format(widget.foodMaster.unitPrice)}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kBlackColor,
            ),
          ),
        ],
      ),
    );
  }

  _deliveryFormat() {
    if (widget.foodMaster.eptTime! > 24) {
      return Text(
        '${widget.foodMaster.eptTime! / 24}' + ' $deliveryDayText',
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else if (widget.foodMaster.eptTime! > 365) {
      return Text(
        '${widget.foodMaster.eptTime! / 365}' + ' $deliveryYearText',
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else {
      return Text(
          '${widget.foodMaster.eptTime.toString()}' + '$deliveryTimeText');
    }
  }

  _insertImagesToList() {
    if (widget.foodMaster.imageA != null) {
      imgList.add(widget.foodMaster.imageA.toString());
    } else {
      imgList.add(widget.logo);
    }
    if (widget.foodMaster.imageB != null) {
      imgList.add(widget.foodMaster.imageB.toString());
    }
    if (widget.foodMaster.imageC != null) {
      imgList.add(widget.foodMaster.imageC.toString());
    }
    if (widget.foodMaster.imageD != null) {
      imgList.add(widget.foodMaster.imageD.toString());
    }
    if (widget.foodMaster.imageE != null) {
      imgList.add(widget.foodMaster.imageE.toString());
    }
  }

  _getFavouriteButton() {
    return MaterialButton(
      minWidth: 30,
      height: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      color: kPrimaryLightColor,
      padding: EdgeInsets.zero,
      onPressed: () {
        _foodsBloc.add(
          FoodFavouriteCreateRequested(
              token: widget.token,
              foodId: int.parse(widget.foodMaster.id.toString()),
              slug: widget.foodMaster.slug!,
              type: widget.type,
              context: context),
        );
      },
      child: HeroIcon(
        HeroIcons.heart,
        color: kHeartColor,
        size: 18,
        solid: widget.foodMaster.isFavourite!
            ? true
            : false, //need to change favourite
      ),
    );
  }
}
