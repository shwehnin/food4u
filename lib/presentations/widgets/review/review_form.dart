import 'package:bestcannedfood_ecommerce/blocs/reviews/reviews_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class AddReviewForm extends StatefulWidget {
  final int foodId;
  final String foodName;
  final String token;
  const AddReviewForm(
      {Key? key,
      required this.foodId,
      required this.foodName,
      required this.token})
      : super(key: key);

  @override
  _AddReviewFormState createState() => _AddReviewFormState();
}

class _AddReviewFormState extends State<AddReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final msgController = TextEditingController();
  double rating = 0;
  var currentIndex = 0;
  String ratingText = '';
  String ratingQuestion = '';
  String value = '';

  late ReviewsBloc _reviewsBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reviewsBloc = BlocProvider.of<ReviewsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ratingStar(),
          SizedBox(
            height: 10,
          ),
          _ratingQuestion,
          SizedBox(
            height: 10,
          ),
          _ratingMsg(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Text(
                    LocaleKeys.your_review_helps_customer.tr(),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          // _submitBtn(),
          rating != 0 ? _submitBtn() : _disableBtn()
        ],
      ),
    );
  }

  Widget _ratingStar() {
    return Row(
      children: [
        SmoothStarRating(
          allowHalfRating: false,
          onRatingChanged: (value) {
            setState(() {
              rating = value;
              _setRatingText(value.toString());
            });
          },
          starCount: 5,
          rating: rating,
          size: 40.0,
          color: kGoldColor,
          borderColor: kGoldColor,
          spacing: 0.0,
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            ratingText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  Widget _ratingMsg() {
    return TextFormField(
      minLines: 6,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: msgController,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        labelText: LocaleKeys.write_your_review.tr(),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _submitBtn() {
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
      minWidth: size.width,
      height: 45,
      color: kPrimaryColor,
      onPressed: () {
        if (msgController.text.isEmpty) {
          EasyLoading.showError(LocaleKeys.your_review_message.tr());
        } else {
          _reviewsBloc.add(ReviewsCreatedRequested(
              message: msgController.text,
              rating: rating,
              foodId: widget.foodId,
              foodName: widget.foodName,
              token: widget.token));
        }
      },
      child: Text(
        LocaleKeys.submit_review.tr(),
        style: TextStyle(
          color: kPrimaryLightColor,
          fontSize: 20,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _disableBtn() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 45,
      child: MaterialButton(
        onPressed: null,
        child: Text(
          LocaleKeys.submit_review.tr(),
          style: TextStyle(
            color: kPrimaryLightColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  void _setRatingText(currentIndex) {
    switch (currentIndex) {
      case "1.0":
        ratingText = LocaleKeys.horrible.tr();
        ratingQuestion = LocaleKeys.did_not_like.tr();
        break;

      case "2.0":
        ratingText = LocaleKeys.bad.tr();
        ratingQuestion = LocaleKeys.was_not_up_mark.tr();
        break;

      case "3.0":
        ratingText = 'Average';
        ratingQuestion = LocaleKeys.was_not_up_mark.tr();
        break;

      case "4.0":
        ratingText = LocaleKeys.good.tr();
        ratingQuestion = LocaleKeys.did_you_like.tr();
        break;

      case "5.0":
        ratingText = LocaleKeys.excellent.tr();
        ratingQuestion = LocaleKeys.did_you_love.tr();
        break;
      default:
        ratingText = LocaleKeys.good.tr();
    }
  }

  get _ratingQuestion {
    return Text(
      ratingQuestion,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
