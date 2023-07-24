import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final EcommerceRepository ecommerceRepository;

  NewsBloc({required this.ecommerceRepository}) : super(InitialNewsListState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    // News List
    if (event is NewsListRequested) {
      yield* _mapNewsListRequestedToState(event);
    }
  }

  // News List
  Stream<NewsState> _mapNewsListRequestedToState(
    NewsListRequested event,
  ) async* {
    if (event.isFirstTime) {
      yield NewsListLoadInProgress();
    }

    try {
      final Map<dynamic, dynamic> newsList =
          await ecommerceRepository.getNewsList(event.keyword, event.sort,
              event.order, event.paginate, event.page);
      yield NewsListLoadSuccess(newsList: newsList);
    } catch (_) {
      yield NewsListLoadFailure();
    }
  }
}
