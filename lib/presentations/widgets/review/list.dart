import 'package:bestcannedfood_ecommerce/blocs/reviews/reviews_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/reviews.dart';
import 'package:bestcannedfood_ecommerce/model/user.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/review/edit_review.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

// ignore: must_be_immutable
class ReviewListItem extends StatefulWidget {
  final Reviews reviews;
  final String token;
  final String id;
  User? user;
  final int page;

  ReviewListItem(
      {Key? key,
      required this.reviews,
      required this.id,
      required this.token,
      this.user,
      required this.page})
      : super(key: key);

  @override
  State<ReviewListItem> createState() => _ReviewListItemState();
}

class _ReviewListItemState extends State<ReviewListItem> {
  bool _isVisible = false;

  void showForm() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.reviews.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    for (int i = 0; i < widget.reviews.starCount; i++)
                      HeroIcon(
                        HeroIcons.star,
                        solid: true,
                        color: kGoldColor,
                        size: 16,
                      )
                  ],
                ),
                widget.token != '' &&
                        widget.user!.customerName == widget.reviews.name
                    ? PopupMenuButton<String>(
                        child: HeroIcon(HeroIcons.dotsHorizontal),
                        onSelected: _handleClick,
                        offset: const Offset(0, 20),
                        elevation: 2.0,
                        itemBuilder: (BuildContext context) {
                          return {'Edit', 'Remove'}.map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Container(
                                  width: 80,
                                  child: Row(
                                    children: [
                                      HeroIcon(
                                        choice.toString() == 'Edit'
                                            ? HeroIcons.pencilAlt
                                            : HeroIcons.trash,
                                        color: Colors.black,
                                        size: 14,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          choice.toString() == 'Edit'
                                              ? LocaleKeys.edit.tr()
                                              : LocaleKeys.remove.tr(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          }).toList();
                        },
                      )
                    : Container(),
              ],
            ),
            Text(
              widget.reviews.date,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.reviews.description,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _handleClick(String value) {
    switch (value) {
      case 'Edit':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditReviewScreen(
                      foodId: widget.reviews.foodId,
                      token: widget.token,
                      message: widget.reviews.description,
                      ratingVale:
                          double.parse(widget.reviews.starCount.toString()),
                      foodName: widget.reviews.foodName,
                      id: widget.id,
                    )));

        break;
      case 'Remove':
        _deleteReview();
        break;
    }
  }

  void _deleteReview() {
    BlocProvider.of<ReviewsBloc>(context)
      ..add(ReviewsDeletedRequested(
          sort: '',
          order: '',
          paginate: 20,
          page: widget.page,
          reviewId: widget.reviews.id,
          token: widget.token,
          foodId: widget.reviews.foodId));
  }
}
