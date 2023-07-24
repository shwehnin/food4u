import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_event.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

class FavoriteItem extends StatelessWidget {
  final FoodMaster foodMaster;
  final String token;
  final String logo;

  FavoriteItem(
      {Key? key,
      required this.foodMaster,
      required this.token,
      required this.logo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/product_detail',
          arguments: foodMaster),
      child: Container(
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? size.height * 0.5
                      : size.height * 0.23,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: foodMaster.imageA != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              foodMaster.imageA!,
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
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width - ((size.width * 0.3) + 80),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            foodMaster.foodName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 18, height: 1.5),
                          ),
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        height: 40,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        color: kButtonBackgroundColor.withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          BlocProvider.of<FavouritesBloc>(context)
                            ..add(FavouriteItemRemoveRequested(
                                foodId: int.parse(foodMaster.id!),
                                token: token,
                                keyword: '',
                                order: '',
                                page: 1,
                                paginate: 20,
                                sort: ''));
                        },
                        child: HeroIcon(
                          HeroIcons.heart,
                          color: kHeartColor,
                          size: 18,
                          solid: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      HeroIcon(HeroIcons.star,
                          size: 17, solid: true, color: kBlackColor),
                      SizedBox(width: 5),
                      Text(
                        "${foodMaster.totalStars.toString()} (${foodMaster.feedbackCount})",
                        style: TextStyle(fontSize: 14, color: kBlackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      HeroIcon(HeroIcons.tag,
                          size: 17, solid: true, color: kBlackColor),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${foodMaster.subCategory!.subCategory}",
                        style: TextStyle(fontSize: 14, color: kBlackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      HeroIcon(
                        HeroIcons.clock,
                        size: 17,
                        color: kBlackColor,
                        solid: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        double.parse(foodMaster.eptTime.toString()).toString() +
                            ' $deliveryTimeText',
                        style: TextStyle(fontSize: 14, color: kBlackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'K ' + currencyFormat.format(foodMaster.unitPrice),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kBlackColor),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
