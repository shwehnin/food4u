import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/reviews.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final EcommerceRepository ecommerceRepository;

  ReviewsBloc({required this.ecommerceRepository})
      : super(InitialPopularFoodsListState());

  @override
  Stream<ReviewsState> mapEventToState(ReviewsEvent event) async* {
    //Reviews List
    if (event is ReviewsListRequested) {
      yield* _mapReviewsListRequestedToState(event);
    }

    if (event is ReviewsDeletedRequested) {
      yield* _mapReviewsDeletedRequestedToState(event);
    }

    if (event is ReviewsCreatedRequested) {
      yield* _mapReviewsCreatedRequestedToState(event);
    }
  }

  // Reviews List
  Stream<ReviewsState> _mapReviewsListRequestedToState(
    ReviewsListRequested event,
  ) async* {
    yield ReviewsListLoadInProgress();

    try {
      final List<Reviews> _reviewsList =
          await ecommerceRepository.getReviewList(event.sort, event.order,
              event.paginate, event.page, event.foodId, event.token);

      yield ReviewsListLoadSuccess(data: _reviewsList);
    } catch (_) {
      yield ReviewsListLoadFailure();
    }
  }

  Stream<ReviewsState> _mapReviewsCreatedRequestedToState(
    ReviewsCreatedRequested event,
  ) async* {
    yield ReviewsCreatedLoadInProgress();

    try {
      final String message = await ecommerceRepository.createdReview(
          event.message,
          event.rating,
          event.foodId,
          event.foodName,
          event.token);

      EasyLoading.showSuccess(message, duration: Duration(milliseconds: 1000));
      yield ReviewsCreatedLoadSuccess(message: message);
    } catch (err) {
      String message = err.toString().replaceAll('Exception: ', '').toString();
      EasyLoading.showInfo(message, duration: Duration(milliseconds: 1000));
      yield ReviewsCreatedLoadFailure(message: message);
    }
  }

  Stream<ReviewsState> _mapReviewsDeletedRequestedToState(
    ReviewsDeletedRequested event,
  ) async* {
    yield ReviewsDeletedLoadInProgress();

    try {
      final String message =
          await ecommerceRepository.deleteReview(event.reviewId, event.token);
      EasyLoading.showSuccess(LocaleKeys.deleted_review.tr(),
          duration: Duration(milliseconds: 1000));

      final List<Reviews> _reviewsList =
          await ecommerceRepository.getReviewList(event.sort, event.order,
              event.paginate, event.page, event.foodId, event.token);

      yield ReviewsListLoadSuccess(data: _reviewsList);
    } catch (_) {
      yield ReviewsDeletedLoadFailure();
    }
  }
}
