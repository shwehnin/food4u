import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/popular_foods/popular_foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

class PopularFoodItem extends StatefulWidget {
  PopularFoodItem(
      {Key? key,
      required this.foodMaster,
      required this.token,
      required this.logo})
      : super(key: key);
  final String token;
  final FoodMaster foodMaster;
  final String logo;

  @override
  State<PopularFoodItem> createState() => _PopularFoodItemState();
}

class _PopularFoodItemState extends State<PopularFoodItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 40) / 3,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
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
                            widget.logo,
                          ),
                        ),
                ),
              ),
              widget.foodMaster.promotionDiscount!.length != 0
                  ? Positioned(
                      bottom: 5,
                      left: 5,
                      right: widget.foodMaster.promotionDiscount![0].strategy
                                  .toString()
                                  .length >
                              20
                          ? 5
                          : null,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: kBlackColor,
                        ),
                        child: Text(
                          widget.foodMaster.promotionDiscount![0].strategy
                                      .toString() !=
                                  'Range Offer'
                              ? widget.foodMaster.promotionDiscount![0].strategy
                                  .toString()
                              : 'Wholesale Offer',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: kPrimaryLightColor,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Positioned(
                right: -5,
                top: -5,
                child: _getFavouriteButton(
                    widget.foodMaster.isFavourite!, context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            child: Text(
              widget.foodMaster.foodName!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              HeroIcon(
                HeroIcons.star,
                size: 17,
                color: Colors.black,
                solid: true,
              ),
              SizedBox(width: 5),
              Text(
                "${widget.foodMaster.totalStars.toString()} (${widget.foodMaster.feedbackCount.toString()})",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          widget.foodMaster.eptTime != 0
              ? Row(
                  children: [
                    HeroIcon(
                      HeroIcons.truck,
                      size: 17,
                      color: kBlackColor,
                      solid: true,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    _deliveryFormat()
                  ],
                )
              : Container(),
          Text(
            'K ' + currencyFormat.format(widget.foodMaster.unitPrice),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: kBlackColor,
            ),
          )
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

  _callFavouriteFunction(context) {
    if (widget.token != '') {
      BlocProvider.of<PopularFoodsBloc>(context).add(
          PopularFavouriteCreateRequested(
              token: widget.token,
              foodId: int.parse(widget.foodMaster.id.toString()),
              context: context));
    } else {
      Navigator.pushNamed(context, '/signin');
    }
  }

  _getFavouriteButton(bool isFavourite, context) {
    return MaterialButton(
      minWidth: 30,
      height: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      color: kPrimaryLightColor,
      padding: EdgeInsets.zero,
      onPressed: () => _callFavouriteFunction(context),
      child: HeroIcon(
        HeroIcons.heart,
        color: kHeartColor,
        size: 18,
        solid: isFavourite, //need to change favourite
      ),
    );
  }
}
