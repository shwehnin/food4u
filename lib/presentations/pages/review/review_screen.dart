import 'package:bestcannedfood_ecommerce/blocs/reviews/reviews_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/review/review_form.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddReviewScreen extends StatefulWidget {
  final int foodId;
  final String foodName;
  final String slug;
  final String token;
  const AddReviewScreen(
      {Key? key,
      required this.foodId,
      required this.foodName,
      required this.slug,
      required this.token})
      : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return BlocConsumer<ReviewsBloc, ReviewsState>(
            builder: (context, state) {
              return _addReviewScaffold;
            },
            listener: (context, state) {
              if (state is ReviewsCreatedLoadSuccess) {
                Navigator.pushReplacementNamed(context, '/product_detail',
                    arguments: FoodMaster(
                        id: widget.foodId.toString(), slug: widget.slug));
              }
            },
          );
        } else {
          return NoInternetWidget();
        }
      },
    );
  }

  get _addReviewScaffold {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomAppBar(
                      leading: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        color: kButtonBackgroundColor.withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, '/product_detail',
                            arguments: FoodMaster(
                                id: widget.foodId.toString(),
                                slug: widget.slug)),
                        child: SvgPicture.asset(
                          "assets/icons/Back ICon.svg",
                          height: 15,
                        ),
                      ),
                      title: LocaleKeys.add_review.tr(),
                      action: []),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddReviewForm(
                        foodId: widget.foodId,
                        token: widget.token,
                        foodName: widget.foodName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
